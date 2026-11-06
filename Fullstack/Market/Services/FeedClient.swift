import Foundation
import Network

struct FeedClient: Sendable {
    /// Delivers a subscription's books until the task is cancelled, reconnecting after each drop.
    ///
    /// Only `receive` runs on the main actor. Connecting, decoding, and waiting all run off it.
    @concurrent
    func stream(_ subscription: Subscription, receive: @MainActor (BookSnapshot) -> Void) async {
        var delay = Duration.seconds(2)
        while !Task.isCancelled {
            try? await connect(subscription, delay: &delay, receive: receive)
            try? await Task.sleep(for: delay)
            delay = min(delay * 2, .seconds(60))
        }
    }

    /// Opens one socket and delivers its books until it fails. The first book resets `delay`.
    private func connect(
        _ subscription: Subscription, delay: inout Duration, receive: @MainActor (BookSnapshot) -> Void
    ) async throws {
        let endpoint = URL(string: "wss://api.hyperliquid.xyz/ws")!
        let connection = NetworkConnection(to: .url(endpoint), using: { WebSocket { TLS() } })
        let request = try JSONEncoder().encode(Request(method: "subscribe", subscription: subscription))
        try await connection.send(String(decoding: request, as: UTF8.self))
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                while !Task.isCancelled {
                    try await Task.sleep(for: .seconds(30))
                    try await connection.send(#"{"method":"ping"}"#)
                }
            }
            defer { group.cancelAll() }
            let decoder = JSONDecoder()
            var book: Book?
            while !Task.isCancelled {
                let data = try await connection.receive().content
                guard let payload = try decoder.decode(Message.self, from: data).data else { continue }
                if let full = payload.s {
                    book = full
                } else if let compressed = payload.c {
                    book?.apply(try BookUpdate(compressed: compressed))
                } else {
                    continue
                }
                guard let book else { continue }
                delay = .seconds(2)
                await receive(BookSnapshot(book))
            }
        }
    }

    private struct Request: Encodable {
        let method: String
        let subscription: Subscription
    }

    /// A message from the server. Only book messages have a snapshot or an update.
    private struct Message: Decodable {
        struct Payload: Decodable {
            /// A full book, sent once when the subscription starts.
            let s: Book?
            /// A compressed ``BookUpdate``.
            let c: String?
        }

        let data: Payload?
    }
}
