// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleConfigurationManager} from "src/SimpleConfigurationManager.sol";

contract TestMulticall is Test {
    SimpleConfigurationManager public configManager;
    address public owner = makeAddr("owner");

    function setUp() external {
        vm.prank(owner);
        configManager = new SimpleConfigurationManager();
        deal(owner, 1e18);
    }

    function testMulticallWorks() external {
        bytes[] memory calls = new bytes[](3);
        calls[0] = abi.encodeCall(configManager.setUintConfig, 1);
        calls[1] = abi.encodeCall(
            configManager.setAddressConfig,
            address(this)
        );
        calls[2] = abi.encodeCall(
            configManager.setAddressToUintConfig,
            (address(this), 2)
        );

        vm.prank(owner);
        configManager.multicall(calls);

        assertEq(configManager.getUintConfig(), 1);
        assertEq(configManager.getAddressConfig(), address(this));
        assertEq(configManager.getAddressToUintConfig(address(this)), 2);
    }

    function testMulticallRevertWithPayableFunc() external {
        bytes[] memory calls = new bytes[](3);
        calls[0] = abi.encodeCall(configManager.setUintConfig, 1);
        calls[1] = abi.encodeCall(
            configManager.setAddressConfig,
            address(this)
        );
        calls[2] = abi.encodeCall(configManager.addUint, 2);

        // @notice you cannot mix payable and non-payable functions in a multicall
        vm.expectRevert();
        vm.prank(owner);
        configManager.multicallPayable{value: 1e18}(calls);
    }
}
