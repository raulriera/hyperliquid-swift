import Foundation

/// The changes to a book since the feed's last message.
struct BookUpdate: Decodable, Sendable {
    struct Level: Decodable, Sendable {
        let p: String
        let s: String
    }

    /// The new or changed levels of each side.
    let l: [[Level]]
    /// The positions that each side removes.
    let r: [[Int]]
    /// The true spread, when the server rounds prices.
    let s: String?

    /// Decodes the Base64 raw DEFLATE form that the feed sends.
    init(compressed: String) throws {
        guard let data = NSData(base64Encoded: compressed) else { throw URLError(.cannotDecodeRawData) }
        self = try JSONDecoder().decode(Self.self, from: data.decompressed(using: .zlib) as Data)
    }
}
