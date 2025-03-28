// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IDEX } from "../interfaces/IDEX.sol";

contract MockDEX is IDEX {
    address public lastPair;
    uint256 public lastInputAmount;
    uint256 public lastOutputAmount;
    uint256 public lastSlippage;

    function getAmountOut(address, uint inputAmount) external pure override returns (uint) {
        return inputAmount * 2;
    }

    function getAmountIn(address, uint outputAmount) external pure override returns (uint) {
        return outputAmount + 10;
    }

    function swapExactTokensForTokens(address pair, uint inputAmount, uint slippage) external override returns (uint) {
        lastPair = pair;
        lastInputAmount = inputAmount;
        lastSlippage = slippage;
        return inputAmount * 2;
    }

    function swapTokensForExactTokens(address pair, uint outputAmount, uint slippage) external override returns (uint) {
        lastPair = pair;
        lastOutputAmount = outputAmount;
        lastSlippage = slippage;
        return outputAmount + 10;
    }
}
