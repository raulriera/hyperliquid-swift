import SwiftUI

/// One region of the book. Stacked, asks sit above bids. Side by side, bids sit left of asks.
struct BookRegion: View {
    @Environment(\.splitArrangementAxis) private var axis
    let isPrimary: Bool
    let book: BookSnapshot?
    let coin: Coin
    @Binding var arrangedAxis: Axis?

    private var isSideBySide: Bool { axis == .horizontal }
    private var isBids: Bool { isSideBySide == isPrimary }

    var body: some View {
        VStack(spacing: 2) {
            if isSideBySide || isPrimary {
                BookColumns(
                    price: Text("Price"),
                    size: Text("Size (\(coin.rawValue))"),
                    total: Text("Total (\(coin.rawValue))"))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else if let amount = book?.spread, let fraction = book?.spreadFraction {
                SpreadRow(amount: amount, fraction: fraction)
            }
            if let book {
                let rows = isBids ? book.bids : book.asks
                ForEach(!isSideBySide && !isBids ? rows.reversed() : rows) { row in
                    BookRow(row: row, isBid: isBids, priceDecimals: book.priceDecimals, sizeDecimals: coin.sizeDecimals)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: axis, initial: true) { _, axis in
            arrangedAxis = axis
        }
    }
}
