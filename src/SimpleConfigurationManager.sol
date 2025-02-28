// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Multicall} from "./Multicall.sol";

contract SimpleConfigurationManager is Multicall {
    uint256 private s_uintConfig;
    address private s_addressConfig;
    mapping(address => uint256) private s_addressToUintConfig;
    address private immutable i_owner;

    error SimpleConfigurationManager__OnlyOwner();

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert SimpleConfigurationManager__OnlyOwner();
        }
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                                SETTERS
    //////////////////////////////////////////////////////////////*/

    function setUintConfig(uint256 _uintConfig) external onlyOwner {
        s_uintConfig = _uintConfig;
    }

    function setAddressConfig(address _addressConfig) external onlyOwner {
        s_addressConfig = _addressConfig;
    }

    function setAddressToUintConfig(
        address _address,
        uint256 _uintConfig
    ) external onlyOwner {
        s_addressToUintConfig[_address] = _uintConfig;
    }

    /*//////////////////////////////////////////////////////////////
                           PAYABLE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice This function is payable to demonstrate that only the multicall function itself payable then it can call other payable functions.
    function addUint(uint256 _uint) external payable onlyOwner {
        s_uintConfig += _uint;
    }

    /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/

    function getUintConfig() external view returns (uint256) {
        return s_uintConfig;
    }

    function getAddressConfig() external view returns (address) {
        return s_addressConfig;
    }

    function getAddressToUintConfig(
        address _address
    ) external view returns (uint256) {
        return s_addressToUintConfig[_address];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
