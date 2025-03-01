# Simple Multicall Demo

This is a simple demo to show how `multicall()` works in a smart contract.

# Why Multicall?

It's not uncommon for users interacting with a smart contract to occasionally need to call multiple functions to perform back-to-back operations to accomplish a single goal. However, most user wallets (EOAs) can only make a single top-level function call in a transaction. Many protocols will simply leave it up to users to make multiple transactions in these cases, or will create specialized top-level wrapper functions for commonly grouped operations (e.g., `wrapETHAndSwap()`).

The multicall pattern provides a simple and robust solution by creating a single top-level function (`multicall()`) that accepts an array of user-encoded calls to execute against its own contract. This function loops through the call data array and performs a `delegatecall()` on itself with each one. This lets the user compose their own sequence of operations to be executed sequentially in a single transaction, without having to predefine the grouping of operations into the protocol.

![multicall-diagram](./img/multicall.svg)

Thanks to `delegatecall` semantics, the address, `msg.value`, and `msg.sender`, and storage will be inherited by each call, and since the `delegatecall` target is ourselves (`address(this)`), the bytecode will be the same as well. This means each call gets executed as if the caller of `multicall()` called those functions directly.

Using multicall, many calls can be executed in a single transaction by passing in the encoded call data for each of those calls into `multicall()`.

## A Note On `payable` Functions

If you intend to support any `payable` functions as part of a multicall, the `multicall()` function istelf should be declared `payable`. Also, multicalled functions cannot be mixed with non-payable multicalled functions if any ETH is attached to `multicall()`. This is because `delegatecall` semantics will inherit the `msg.value` of the top-level `multicall()` call. Non-payable functions assert that `msg.value == 0`, so they will revert if `multicall()` is called with ETH attached. The easy way around this is to add `payable` to all functions that can be multi-called to bypass the check, but you should carefully evaluate what security implications this could introduce to those functions.

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.3.0 (5a8bd89 2024-12-19T17:17:10.245193696Z)`

## Quickstart

```
git clone https://github.com/cqlyj/simple-multicall-demo
cd simple-multicall-demo
forge build
```

# Usage

Simply run `forge test -vvvv` to see how `multicall()` can be used to execute multiple functions in a single transaction.

## Contact

Luo Yingjie - [luoyingjie0721@gmail.com](luoyingjie0721@gmail.com)
