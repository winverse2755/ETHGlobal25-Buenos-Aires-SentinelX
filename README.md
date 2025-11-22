# SentinelX Contracts

Smart contracts that enable cross-chain token freezing using Hyperlane messaging infrastructure.

The `CrossChainFreezer` contract coordinates freeze operations across multiple chains. When triggered, it pauses tokens locally and dispatches freeze messages via Hyperlane to remote chains, ensuring synchronized protection across all networks. Includes pausable ERC20 token implementation for demonstration.

## Setup

```bash
forge install
```

## Build

```bash
forge build
```

## Test

```bash
forge test
```

## Deploy

```bash
forge script script/CrossChainFreezer.s.sol:CrossChainFreezerScript \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify
```

## Main Contracts

- `CrossChainFreezer.sol` - Cross-chain freeze orchestration
- `SampleUSDC.sol` - Pausable ERC20 token implementation

## Dependencies

- Hyperlane Monorepo
- OpenZeppelin Contracts
- forge-std
