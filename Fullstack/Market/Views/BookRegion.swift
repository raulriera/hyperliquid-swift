import SwiftUI

/// One region of the book. Stacked, asks sit above bids. Side by side, bids sit left of asks.
struct BookRegion: View {
    @Environment(\.splitArrangementAxis) private var axis
    let isPrimary: Bool
    let book: BookSnapshot?
    @Binding var arrangedAxis: Axis?

    private var isSideBySide: Bool { axis == .horizontal }
    private var isBids: Bool { isSideBySide == isPrimary }

    var body: some View {
        VStack(spacing: 1) {
            if isSideBySide || isPrimary {
                BookColumns(price: Text("Price"), size: Text("Size"), total: Text("Total"))
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else if let amount = book?.spread, let fraction = book?.spreadFraction {
                SpreadRow(amount: amount, fraction: fraction)
            }
            if let book {
                let rows = isBids ? book.bids : book.asks
                ForEach(!isSideBySide && !isBids ? rows.reversed() : rows) { row in
                    BookRow(
                        price: row.price, size: row.size, total: row.total, fill: row.fill, isBid: isBids,
                        priceDecimals: book.priceDecimals, sizeDecimals: book.coin.sizeDecimals)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: axis, initial: true) { _, axis in
            arrangedAxis = axis
        }
    }
}
