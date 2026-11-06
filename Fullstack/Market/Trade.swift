struct Trade: Decodable, Identifiable, Sendable {
    enum Side: String, Decodable, Sendable {
        case buy = "B"
        case sell = "A"
    }

    let side: Side
    let px: String
    let sz: String
    let time: Int
    let tid: Int

    var id: String { "\(time)-\(tid)" }
}
