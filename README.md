# PriceSVG

On-chain price board that stores token prices and renders a small SVG dashboard. Built with Foundry for quick local iteration and testing.

## What it does
- Owner-managed price registry; symbols are case-sensitive and reverts on empty input.
- Emits `PriceUpdated` for every write; keeps an ordered list of symbols for deterministic SVG rows.
- Renders a dark, monospace SVG card showing every tracked symbol/value pair and reverts if no prices exist.

## Quick start
1) Install Foundry (`forge`, `cast`): `curl -L https://foundry.paradigm.xyz | bash` then `foundryup`.
2) Install deps (includes `forge-std`): `forge install`.
3) Run tests: `forge test`.
4) Format (if you touch Solidity): `forge fmt`.

## Usage examples
- Deploy: `forge create src/PriceSVG.sol:PriceSVG --rpc-url $RPC_URL --private-key $PK`.
- Update a price (owner only): `cast send $ADDRESS "setPrice(string,int256)" "ETH" 1800 --rpc-url $RPC_URL --private-key $PK`.
- Read a price: `cast call $ADDRESS "priceOf(string)(int256,bool)" "ETH" --rpc-url $RPC_URL`.
- Render SVG: `cast call $ADDRESS "svg()(string)" --rpc-url $RPC_URL`.

## Repository layout
- `src/PriceSVG.sol`: Contract logic for storing prices and composing the SVG output.
- `test/PriceSVG.t.sol`: Coverage for owner writes, empty symbols, missing prices, and SVG content.
- `foundry.toml`: Build/profile config (Solidity 0.8.23, optimizer enabled).
- `remappings.txt`, `lib/`: Dependency wiring for `forge-std`.
- `scripts/`: Reserved for future deployment/interaction scripts.
