# Hyperliquid Swift

A native iOS and iPadOS order book for [Hyperliquid](https://hyperliquid.xyz), built with SwiftUI and Apple frameworks only.

- Live BTC and ETH order books, updating about twice a second
- Adjustable price precision
- An adaptive layout that stacks the two sides or places them side by side, depending on the space available

## Requirements

- Xcode 27.2 or later
- An iOS 27.2 or later simulator or device

The app reads public market data, so it needs no account or API key.

## Run the app

1. Clone the repository:

   ```bash
   git clone git@github.com:raulriera/hyperliquid-swift.git
   ```

2. Open `Fullstack.xcodeproj` in Xcode.
3. Choose the `Fullstack` scheme and an iPhone or iPad simulator.
4. Press ⌘R.

To run on a device, choose your team and a unique bundle identifier in the `Fullstack` target's Signing & Capabilities settings.

## Run the tests

Build the app once, then choose the `FullstackTests` scheme and press ⌘U.
