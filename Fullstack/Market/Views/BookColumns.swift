import SwiftUI

/// The three aligned columns that the book's header and rows share.
struct BookColumns<Price: View>: View {
    let price: Price
    let size: Text
    let total: Text

    var body: some View {
        HStack(spacing: 8) {
            price.frame(maxWidth: .infinity, alignment: .leading)
            size.frame(maxWidth: .infinity, alignment: .trailing)
            total.frame(maxWidth: .infinity, alignment: .trailing)
        }
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .padding(.horizontal)
    }
}
