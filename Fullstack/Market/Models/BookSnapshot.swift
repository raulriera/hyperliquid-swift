import Foundation

/// A book with everything the screen shows worked out once, while decoding off the main actor.
struct BookSnapshot: Decodable, Equatable, Sendable {
    /// A level with the running total of its side.
    ///
    /// A row is identified by its rank, not its price, so that it survives price moves and animates to its new
    /// values. Identified by price, a row is replaced without animation whenever its price leaves the book.
    struct Row: Equatable, Identifiable, Sendable {
        /// The position in the side, where 0 is the best price.
        let id: Int
        let price: Decimal
        let size: Decimal
        let total: Decimal
        /// The share of the deeper side's total that this row reaches, from 0 to 1.
        let fill: Double
    }

    let coin: Coin
    let bids: [Row]
    let asks: [Row]
    /// The most decimals that any price needs, so that all of them can line up.
    let priceDecimals: Int
    /// The gap between the best prices.
    let spread: Decimal?
    /// The spread as a fraction of the midpoint between the best prices.
    let spreadFraction: Decimal?

    init(from decoder: any Decoder) throws {
        self.init(try Book(from: decoder))
    }

    init(_ book: Book) {
        let bidTotals = Self.totals(of: book.bids)
        let askTotals = Self.totals(of: book.asks)
        let depth = max(bidTotals.last ?? 0, askTotals.last ?? 0)
        coin = book.coin
        bids = Self.rows(from: book.bids, totals: bidTotals, depth: depth)
        asks = Self.rows(from: book.asks, totals: askTotals, depth: depth)
        priceDecimals = (bids + asks).map { max(0, -Int($0.price.exponent)) }.max() ?? 0
        if let bid = bids.first?.price, let ask = asks.first?.price {
            let spread = book.spread.flatMap { Decimal(string: $0) } ?? ask - bid
            self.spread = spread
            spreadFraction = spread / ((bid + ask) / 2)
        } else {
            spread = nil
            spreadFraction = nil
        }
    }

    private static func totals(of levels: [Book.Level]) -> [Decimal] {
        var total = Decimal.zero
        return levels.map { level in
            total += Decimal(string: level.sz) ?? 0
            return total
        }
    }

    private static func rows(from levels: [Book.Level], totals: [Decimal], depth: Decimal) -> [Row] {
        zip(levels, totals).enumerated().map { rank, level in
            Row(
                id: rank, price: Decimal(string: level.0.px) ?? 0, size: Decimal(string: level.0.sz) ?? 0,
                total: level.1, fill: Double(truncating: (level.1 / depth) as NSDecimalNumber))
        }
    }
}
