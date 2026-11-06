import Foundation

/// The levels of one coin's book, kept up to date from the feed.
struct Book: Decodable, Equatable, Sendable {
    struct Level: Decodable, Equatable, Sendable {
        let px: String
        let sz: String
    }

    /// The levels the feed keeps per side. Beyond this it stops tracking them, so they would go stale.
    private static let levelsPerSide = 20

    let coin: Coin
    private(set) var levels: [[Level]]
    /// The true spread, which the server sends only when it rounds prices.
    private(set) var spread: String?

    var bids: [Level] { levels[0] }
    var asks: [Level] { levels[1] }

    /// Applies an update. Its removals are positions in the book before the update, so they come first.
    mutating func apply(_ update: BookUpdate) {
        levels = levels.indices.map { side in
            let removed = Set(update.r[side])
            var merged: [String: Level] = [:]
            for (position, level) in levels[side].enumerated() where !removed.contains(position) {
                merged[level.px] = level
            }
            for level in update.l[side] {
                merged[level.p] = Level(px: level.p, sz: level.s)
            }
            let sorted = merged.values.sorted { first, second in
                let (low, high) = (Decimal(string: first.px) ?? 0, Decimal(string: second.px) ?? 0)
                return side == 0 ? low > high : low < high
            }
            return Array(sorted.prefix(Self.levelsPerSide))
        }
        spread = update.s
    }
}
