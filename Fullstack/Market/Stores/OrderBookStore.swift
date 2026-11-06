import Observation

/// The live market of one window. Run `streamBook()` and `streamTrades()` with `task(id:)` so that
/// a new selection restarts them.
@MainActor @Observable
final class OrderBookStore {
    var coin = Coin.btc
    var precision: Precision?
    private(set) var book: Book?
    private(set) var trades: [Trade] = []

    func streamBook() async {
        await FeedClient().stream(.book(coin, precision: precision)) { (book: Book) in self.book = book }
    }

    func streamTrades() async {
        await FeedClient().stream(.trades(coin)) { (batch: [Trade]) in self.merge(batch) }
    }

    /// Puts new trades first, skipping those a reconnect replays and those of a previous coin.
    private func merge(_ batch: [Trade]) {
        let known = Set(trades.map(\.id))
        let new = batch.reversed().filter { !known.contains($0.id) }
        trades = Array((new + trades.filter { $0.coin == coin }).prefix(50))
    }
}
