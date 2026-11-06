import Foundation
import Network

struct FeedClient: Sendable {
    /// Opens a socket for a subscription and streams its payloads. Ending the stream closes the socket.
    func events<Payload: Decodable & Sendable>(for subscription: Subscription) -> AsyncThrowingStream<Payload, any Error> {
        AsyncThrowingStream { continuation in
            let task = Task { @concurrent in
                do {
                    try await run(subscription) { continuation.yield($0) }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    private func run<Payload: Decodable & Sendable>(
        _ subscription: Subscription, deliver: @escaping @Sendable (Payload) -> Void
    ) async throws {
        let endpoint = URL(string: "wss://api.hyperliquid.xyz/ws")!
        let connection = NetworkConnection(to: .url(endpoint), using: { WebSocket { TLS() } })
        let request = try JSONEncoder().encode(Request(method: "subscribe", subscription: subscription))
        try await connection.send(String(decoding: request, as: UTF8.self))
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                while true {
                    let data = try await connection.receive().content
                    let decoder = JSONDecoder()
                    if try decoder.decode(Channel.self, from: data).channel == subscription.type {
                        deliver(try decoder.decode(Message<Payload>.self, from: data).data)
                    }
                }
            }
            group.addTask {
                while true {
                    try await Task.sleep(for: .seconds(30))
                    try await connection.send(#"{"method":"ping"}"#)
                }
            }
            defer { group.cancelAll() }
            try await group.next()
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
