import SwiftUI

struct BookRow: View {
    let price: Decimal
    let size: Decimal
    let total: Decimal
    /// The share of the row that its depth bar covers, from 0 to 1.
    let fill: Double
    let isBid: Bool
    let priceDecimals: Int
    let sizeDecimals: Int

    private var tint: Color { isBid ? .bookBid : .bookAsk }
    private var sizeFormat: Decimal.FormatStyle { .number.precision(.fractionLength(sizeDecimals)) }

    var body: some View {
        BookColumns(
            price: Text(price, format: .number.precision(.fractionLength(priceDecimals)))
                .fontWeight(.medium)
                .foregroundStyle(tint)
                .contentTransition(.numericText())
                .animation(.snappy, value: price),
            size: Text(size, format: sizeFormat),
            total: Text(total, format: sizeFormat))
            .font(.callout)
            .frame(maxHeight: .infinity)
            .background {
                Rectangle()
                    .fill(tint.opacity(0.16))
                    .animation(.snappy) { $0.scaleEffect(x: fill, y: 1, anchor: .leading) }
            }
            .accessibilityElement(children: .combine)
    }
}
