# PriceSVG

On-chain price board that stores token prices and renders a minimal SVG dashboard. Built with Foundry.

## Prerequisites
- Foundry toolchain installed (`forge`, `cast`). Install via `curl -L https://foundry.paradigm.xyz | bash` then run `foundryup`.

## Setup
1) Install dependencies (includes `forge-std`):
   ```bash
   forge install
   ```
2) Verify remappings (already configured): `remappings.txt` maps `forge-std/=lib/forge-std/src/`.

## Testing
- Run unit tests:
  ```bash
  forge test
  ```

## Project Structure
- `src/PriceSVG.sol`: Contract storing prices and generating the SVG display.
- `test/PriceSVG.t.sol`: Foundry tests covering price updates, access control, and SVG output.
- `scripts/`: Reserved for future deployment or interaction scripts.
