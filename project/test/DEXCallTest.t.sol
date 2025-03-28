// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { BaseTest } from "./BaseTest.t.sol";
import { Core } from "../src/Core.sol";
import { console } from "forge-std/console.sol";
import { DEXConnector } from "../src/connectors/DEXConnector.sol";
import { MockDEX } from "../src/mocks/MockDEX.sol";

contract DexCallTest is BaseTest {
    DEXConnector dexConnector;
    MockDEX mockDex;

    function setUp() public override {
        super.setUp();
        dexConnector = new DEXConnector();
        mockDex = new MockDEX();

        vm.startPrank(DEV);
        core.setDEX(address(mockDex));
        core.setDexConnector(address(dexConnector));
        core.createAccount(USER_TELEGRAMID);
        vm.stopPrank();
    }

    function testSwapExactTokensForTokens() public {
        uint256 inputAmount = 1000;
        uint256 slippage = 3;
        address pair = makeAddr("Pair");

        bytes memory data = abi.encodeWithSelector(
            DEXConnector.swapExactTokensForTokens.selector,
            address(mockDex),
            pair,
            inputAmount,
            slippage
        );

        vm.expectCall(address(dexConnector), data);

        vm.startPrank(DEV);
        core.excuteDexCall(USER_TELEGRAMID, data);
        vm.stopPrank();

        assertEq(mockDex.lastPair(), pair);
        assertEq(mockDex.lastInputAmount(), inputAmount);
        assertEq(mockDex.lastSlippage(), slippage);
    }

    function testSwapTokensForExactTokens() public {
        uint256 outputAmount = 500;
        uint256 slippage = 2;
        address pair = makeAddr("Pair");

        bytes memory data = abi.encodeWithSelector(
            DEXConnector.swapTokensForExactTokens.selector,
            address(mockDex),
            pair,
            outputAmount,
            slippage
        );

        vm.expectCall(address(dexConnector), data);

        vm.startPrank(DEV);
        core.excuteDexCall(USER_TELEGRAMID, data);
        vm.stopPrank();

        assertEq(mockDex.lastPair(), pair);
        assertEq(mockDex.lastOutputAmount(), outputAmount);
        assertEq(mockDex.lastSlippage(), slippage);
    }

    function testGetAmountOut() public {
        uint256 inputAmount = 2000;
        address pair = makeAddr("Pair");

        uint256 expected = mockDex.getAmountOut(pair, inputAmount);

        uint256 result = dexConnector.getAmountOut(address(mockDex), pair, inputAmount);
        assertEq(result, expected);
    }

    function testGetAmountIn() public {
        uint256 outputAmount = 1000;
        address pair = makeAddr("Pair");

        uint256 expected = mockDex.getAmountIn(pair, outputAmount);

        uint256 result = dexConnector.getAmountIn(address(mockDex), pair, outputAmount);
        assertEq(result, expected);
    }
}
