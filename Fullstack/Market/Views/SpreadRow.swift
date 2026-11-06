import SwiftUI

struct SpreadRow: View {
    let amount: Decimal
    /// The spread as a fraction of the midpoint, such as 0.00001 for 0.001%.
    let fraction: Decimal

    var body: some View {
        HStack(spacing: 24) {
            Text("Spread").foregroundStyle(.secondary)
            Text(amount, format: .number)
            Text(fraction, format: .percent.precision(.fractionLength(3)))
        }
        .font(.footnote.weight(.medium))
        .monospacedDigit()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(.bookSurface, ignoresSafeAreaEdges: [])
        .accessibilityElement(children: .combine)
    }
}
