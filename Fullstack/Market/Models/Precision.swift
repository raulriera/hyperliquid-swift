/// The significant figures of book prices. No value means full precision.
enum Precision: Int, CaseIterable, Encodable, Sendable {
    case two = 2, three, four, five
}
