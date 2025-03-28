// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IDEX
/// @notice Interface for the DEX contract
interface IDEX {
    /// @notice Executes a swap between two tokens fromToken, toToken, amount
    function swap(address _fromToken, address _tokenOut, uint256 _amount) external;
}