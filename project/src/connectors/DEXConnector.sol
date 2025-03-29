// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

import { IDEX } from "../interfaces/IDEX.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IDEX } from "../interfaces/IDEX.sol";
import { IPool } from "../interfaces/IPool.sol";

contract DEXConnector {

    function swapExactTokensForTokens(
        address dex,
        address pairAddress,
        uint256 inputAmount,
        uint256 slippagePercent
    ) external returns (uint256 amountOut) {
        IERC20(IPool(pairAddress).token0()).approve(dex, inputAmount);
        amountOut = IDEX(dex).swapExactTokensForTokens(pairAddress, inputAmount, slippagePercent);
    }

    function swapTokensForExactTokens(
        address dex,
        address pairAddress,
        uint256 outputAmount,
        uint256 slippagePercent
    ) external returns (uint256 inputUsed) {
        uint256 amount= _getAmountIn(dex, pairAddress, outputAmount);
        IERC20(IPool(pairAddress).token1()).approve(dex, amount);
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
        amountIn = _getAmountIn(dex, pairAddress, outputAmount);
    }

    function _getAmountIn(
        address dex,
        address pairAddress,
        uint256 outputAmount
    ) internal view returns (uint256 amountIn) {
        amountIn = IDEX(dex).getAmountIn(pairAddress, outputAmount);
    }
}
