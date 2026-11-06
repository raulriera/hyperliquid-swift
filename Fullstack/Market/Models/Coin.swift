enum Coin: String, CaseIterable, Codable, Sendable {
    case btc = "BTC"
    case eth = "ETH"

    /// The decimals of this coin's sizes, as the server's `meta` reports them.
    var sizeDecimals: Int {
        switch self {
        case .btc: 5
        case .eth: 4
        }
    }
}
