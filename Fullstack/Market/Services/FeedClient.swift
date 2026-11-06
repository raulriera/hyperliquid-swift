import Foundation
import Network

struct FeedClient: Sendable {
    /// Delivers a subscription's payloads until the task is cancelled, reconnecting after each drop.
    ///
    /// Only `receive` runs on the main actor. Connecting, decoding, and waiting all run off it.
    @concurrent
    func stream<Payload: Decodable & Sendable>(_ subscription: Subscription, receive: @MainActor (Payload) -> Void) async {
        var delay = Duration.seconds(2)
        while !Task.isCancelled {
            try? await connect(subscription, delay: &delay, receive: receive)
            try? await Task.sleep(for: delay)
            delay = min(delay * 2, .seconds(60))
        }
    }

    /// Opens one socket and delivers its payloads until it fails. The first payload resets `delay`.
    private func connect<Payload: Decodable & Sendable>(
        _ subscription: Subscription, delay: inout Duration, receive: @MainActor (Payload) -> Void
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
            while !Task.isCancelled {
                let data = try await connection.receive().content
                guard try decoder.decode(Channel.self, from: data).channel == subscription.type else { continue }
                let payload = try decoder.decode(Message<Payload>.self, from: data).data
                delay = .seconds(2)
                await receive(payload)
            }
        }
    }

    private struct Request: Encodable {
        let method: String
        let subscription: Subscription
    }

    private struct Channel: Decodable {
        let channel: String
    }

    private struct Message<Payload: Decodable>: Decodable {
        let data: Payload
    }
}
