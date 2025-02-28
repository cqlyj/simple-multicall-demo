// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Multicall} from "./Multicall.sol";

contract SimpleConfigurationManager is Multicall {
    uint256 private s_uintConfig;
    address private s_addressConfig;
    mapping(address => uint256) private s_addressToUintConfig;

    /*//////////////////////////////////////////////////////////////
                                SETTERS
    //////////////////////////////////////////////////////////////*/

    function setUintConfig(uint256 _uintConfig) external {
        s_uintConfig = _uintConfig;
    }

    function setAddressConfig(address _addressConfig) external {
        s_addressConfig = _addressConfig;
    }

    function setAddressToUintConfig(
        address _address,
        uint256 _uintConfig
    ) external {
        s_addressToUintConfig[_address] = _uintConfig;
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
}
