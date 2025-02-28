// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @notice If you intend to support any payable functions as part of a multicall, the multicall() function istelf should be declared payable.
/// Also, multicalled functions cannot be mixed with non-payable multicalled functions if any ETH is attached to multicall().
/// This is because delegatecall semantics will inherit the msg.value of the top-level multicall() call.
/// Non-payable functions assert that msg.value == 0, so they will revert if multicall() is called with ETH attached.
/// The easy way around this is to add payable to all functions that can be multi-called to bypass the check.
/// But you should carefully evaluate what security implications this could introduce to those functions.

contract Multicall {
    function multicall(
        bytes[] calldata data
    ) external returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(
                data[i]
            );

            if (!success) {
                // bubble up the revert reason
                assembly {
                    revert(add(result, 0x20), mload(result))
                }
            }

            results[i] = result;
        }
    }
}
