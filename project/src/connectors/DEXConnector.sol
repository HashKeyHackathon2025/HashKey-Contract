// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

import { IDEX } from "../interfaces/IDEX.sol";

contract DEXConnector {

    function swapExactTokensForTokens(
        address dex,
        address pairAddress,
        uint256 inputAmount,
        uint256 slippagePercent
    ) external returns (uint256 amountOut) {
        amountOut = IDEX(dex).swapExactTokensForTokens(pairAddress, inputAmount, slippagePercent);
    }

    function swapTokensForExactTokens(
        address dex,
        address pairAddress,
        uint256 outputAmount,
        uint256 slippagePercent
    ) external returns (uint256 inputUsed) {
        inputUsed = IDEX(dex).swapTokensForExactTokens(pairAddress, outputAmount, slippagePercent);
    }

    function getAmountOut(
        address dex,
        address pairAddress,
        uint256 inputAmount
    ) external view returns (uint256 amountOut) {
        amountOut = IDEX(dex).getAmountOut(pairAddress, inputAmount);
    }

    function getAmountIn(
        address dex,
        address pairAddress,
        uint256 outputAmount
    ) external view returns (uint256 amountIn) {
        amountIn = IDEX(dex).getAmountIn(pairAddress, outputAmount);
    }
}
