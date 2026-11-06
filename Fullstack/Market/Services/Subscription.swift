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
