import SwiftUI

struct RootView: View {
    @State private var store = OrderBookStore()

    var body: some View {
        NavigationStack {
            OrderBookScreen(store: store)
        }
    }
}
