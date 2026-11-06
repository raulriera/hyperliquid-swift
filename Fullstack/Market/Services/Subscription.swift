/// The body of a subscribe request for the fast book feed.
struct Subscription: Encodable, Hashable, Sendable {
    enum Channel: String, Encodable, Sendable {
        case book = "l2Book"
    }

    var type = Channel.book
    let coin: Coin
    let nSigFigs: Precision?
    var fast = true
}
