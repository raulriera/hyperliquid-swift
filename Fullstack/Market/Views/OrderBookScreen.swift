import SwiftUI

struct OrderBookScreen: View {
    @Bindable var store: OrderBookStore
    @State private var axis: Axis?

    var body: some View {
        VStack(spacing: 0) {
            if axis == .horizontal, let amount = store.book?.spread, let fraction = store.book?.spreadFraction {
                SpreadRow(amount: amount, fraction: fraction)
            }
            ArrangementView {
                BookRegion(isPrimary: true, book: store.book, arrangedAxis: $axis)
            } secondary: {
                BookRegion(isPrimary: false, book: store.book, arrangedAxis: $axis)
                    .layoutPriority(1)
            }
            .arrangementViewStyle(.split)
        }
        .navigationTitle("Order Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Picker("Precision", selection: $store.precision) {
                    Label("Full", systemImage: "number.circle.fill").tag(Precision?.none)
                    ForEach(Precision.allCases, id: \.self) { precision in
                        Label("\(precision.rawValue)", systemImage: "\(precision.rawValue).circle.fill").tag(Precision?.some(precision))
                    }
                }
                .pickerStyle(.menu)
                .labelStyle(.iconOnly)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Coin", selection: $store.coin) {
                    ForEach(Coin.allCases, id: \.self) { coin in
                        Label(coin.rawValue, systemImage: coin == .btc ? "bitcoinsign.circle.fill" : "diamond.circle.fill").tag(coin)
                    }
                }
                .pickerStyle(.menu)
                .labelStyle(.iconOnly)
            }
        }
        .background(.bookBackground)
        .task(id: store.subscription) {
            await store.streamBook()
        }
    }
}
