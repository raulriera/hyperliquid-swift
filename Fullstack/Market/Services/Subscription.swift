/// The body of a subscribe request for the `l2` book feed.
///
/// This is the feed that Hyperliquid's own site uses. It isn't in the public documentation, but it delivers 20 levels
/// twice a second, where the documented feed offers 20 levels every five seconds or 5 levels twice a second.
struct Subscription: Encodable, Hashable, Sendable {
    enum Channel: String, Encodable, Sendable {
        case book = "l2"
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coin = "c"
        case precision = "s"
    }

    var type = Channel.book
    let coin: Coin
    let precision: Precision?
}
