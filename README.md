## Learning Foundry
**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:
- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation
https://book.getfoundry.sh/

## Usage

### Compile
```shell
$ forge create <contractName> --interactive
// --interactive to prompt the private key or the url
// --rpc-url , default using anvil 
```

## Development private keys
## Anvil 
```shell
## Ran it detached 
anvil > anvil.log 2>&1 &
ps aux | grep anvil
kill <PID>
or
jobs
kill %<jobId>
```

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
forge test --fork-url <RPC_URL>
forge coverage # test coverage
forge inspect <CONTRACT> storageLayout
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Install Contracts
### Chainlink contracts
```
forge install smartcontractkit/chainlink-evm@contracts-v<version>
# Add to foundry.toml:
remappings = [
  '@chainlink/contracts/=lib/chainlink-evm/contracts/',
]
```

## Cheatcodes
1. `vm`
    * `.deal(USER, STARTING_BALANCE)`
    * `prank(USER)`
    * `txGasPrice(PRICE)`
        
2. `makeAddr`
3. `hoax`

