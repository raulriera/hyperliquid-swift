import SwiftUI

struct BookRow: View {
    let row: BookSnapshot.Row
    let isBid: Bool
    let priceDecimals: Int
    let sizeDecimals: Int

    private var tint: Color { isBid ? .green : .red }
    private var sizeFormat: Decimal.FormatStyle { .number.precision(.fractionLength(sizeDecimals)) }

    var body: some View {
        BookColumns(
            price: Text(row.price, format: .number.precision(.fractionLength(priceDecimals))).foregroundStyle(tint),
            size: Text(row.size, format: sizeFormat),
            total: Text(row.total, format: sizeFormat))
            .contentTransition(.numericText())
            .animation(.snappy, value: row)
            .geometryGroup()
            .frame(maxHeight: .infinity)
            .background {
                Rectangle()
                    .fill(tint.opacity(0.18))
                    .animation(.snappy) { $0.scaleEffect(x: row.fill, y: 1, anchor: .leading) }
            }
            .accessibilityElement(children: .combine)
    }
}
