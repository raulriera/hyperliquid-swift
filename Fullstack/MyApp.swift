import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Order Book", systemImage: "book.pages") {
                    EmptyView()
                }
                Tab("Trades", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90") {
                    EmptyView()
                }
            }
        }
    }
}
