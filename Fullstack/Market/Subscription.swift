enum Coin: String, CaseIterable, Codable, Sendable {
    case btc = "BTC"
    case eth = "ETH"
}

/// The significant figures of book prices. No value means full precision.
enum Precision: Int, CaseIterable, Encodable, Sendable {
    case two = 2, three, four, five
}

struct Subscription: Encodable, Sendable {
    let type: String
    let coin: Coin
    var nSigFigs: Precision?
    var fast: Bool?

    static func book(_ coin: Coin, precision: Precision?) -> Subscription {
        Subscription(type: "l2Book", coin: coin, nSigFigs: precision, fast: true)
    }

    static func trades(_ coin: Coin) -> Subscription {
        Subscription(type: "trades", coin: coin)
    }
}
