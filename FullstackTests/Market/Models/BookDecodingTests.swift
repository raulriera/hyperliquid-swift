import Foundation
import Testing
@testable import Fullstack

struct BookDecodingTests {
    private let json = #"{"coin":"BTC","levels":[[{"px":"100.0","sz":"1"},{"px":"99.0","sz":"2"},{"px":"98.0","sz":"3"}],[{"px":"101.0","sz":"4"},{"px":"102.0","sz":"5"}]]}"#

    @Test
    func `The first side is bids and the second is asks`() throws {
        let book = try JSONDecoder().decode(Book.self, from: Data(json.utf8))

        #expect(book.bids.first?.px == "100.0")
        #expect(book.asks.first?.px == "101.0")
    }

    @Test
    func `An update removes old positions, then adds levels in price order`() throws {
        var book = try JSONDecoder().decode(Book.self, from: Data(json.utf8))
        let update = #"{"l":[[{"p":"97.0","s":"7"},{"p":"99.0","s":"8"}],[]],"r":[[0],[1]]}"#

        book.apply(try JSONDecoder().decode(BookUpdate.self, from: Data(update.utf8)))

        #expect(book.bids.map(\.px) == ["99.0", "98.0", "97.0"])
        #expect(book.bids.map(\.sz) == ["8", "3", "7"])
        #expect(book.asks.map(\.px) == ["101.0"])
    }
}
