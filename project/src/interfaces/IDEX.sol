// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IDEX
/// @notice Interface for the DEX contract
interface IDEX {
    // Calculate output amount by input amount
    function getAmountOut(address pairAddress, uint inputAmount) external view returns (uint);

    // Calculate input amount by output amount
    function getAmountIn(address pairAddress, uint outputAmount) external view returns (uint);

    // input 값 지정 swap
    function swapExactTokensForTokens(address pairAddress, uint inputAmount, uint slippagePercent) external returns (uint);

    // output 값 지정 swap
    function swapTokensForExactTokens(address pairAddress, uint outputAmount, uint slippagePercent) external returns (uint);
}