import Foundation
import Testing
@testable import Fullstack

struct BookDecodingTests {
    @Test
    func `The first side is bids and the second is asks`() throws {
        let json = #"{"coin":"BTC","levels":[[{"px":"75000.0","sz":"1.5","n":4}],[{"px":"76000.0","sz":"2.5","n":7}]]}"#
        let book = try JSONDecoder().decode(Book.self, from: Data(json.utf8))

        #expect(book.bids.first?.px == "75000.0")
        #expect(book.asks.first?.px == "76000.0")
    }
}
