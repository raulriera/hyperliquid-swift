struct Book: Decodable, Equatable, Sendable {
    struct Level: Decodable, Equatable, Sendable {
        let px: String
        let sz: String
        let n: Int
    }

    let coin: Coin
    let levels: [[Level]]
    /// The true spread, which the server sends only when it rounds prices.
    let spread: String?

    var bids: [Level] { levels[0] }
    var asks: [Level] { levels[1] }
}
