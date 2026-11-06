import SwiftUI

struct SpreadRow: View {
    let amount: Decimal
    /// The spread as a fraction of the midpoint, such as 0.00001 for 0.001%.
    let fraction: Decimal

    var body: some View {
        HStack(spacing: 24) {
            Text("Spread")
            Text(amount, format: .number)
            Text(fraction, format: .percent.precision(.fractionLength(3)))
        }
        .font(.callout)
        .monospacedDigit()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(.quaternary, ignoresSafeAreaEdges: [])
        .accessibilityElement(children: .combine)
    }
}
