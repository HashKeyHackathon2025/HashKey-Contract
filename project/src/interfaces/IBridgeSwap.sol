// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IBridgeSwap {
    struct SwapParams {
        address tokenIn;
        uint256 amountIn;
        uint256 minAmountOut;
        uint256 targetChainId;
        address recipient;
    }
    
    function executeBridgeSwap(SwapParams calldata params) external payable;
}