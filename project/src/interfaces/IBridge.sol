// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IBridge {
    function deposit(address token, uint256 amount, string calldata targetChainAddress) external;
}
