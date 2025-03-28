// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IDEX
/// @notice Interface for the DEX contract
interface IDEX {
    /// @notice Executes a swap between two tokens
    function swap(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin, address _to) external;
}