import Observation

/// The live book of one window. Run `streamBook()` with `task(id: subscription)` so that a new selection restarts it.
@MainActor @Observable
final class OrderBookStore {
    var coin = Coin.btc
    var precision: Precision?
    private(set) var book: BookSnapshot?

    var subscription: Subscription { Subscription(coin: coin, nSigFigs: precision) }

    func streamBook() async {
        await FeedClient().stream(subscription) { self.book = $0 }
    }
}
