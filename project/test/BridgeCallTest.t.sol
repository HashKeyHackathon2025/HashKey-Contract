// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { BaseTest } from "./BaseTest.t.sol";
import { Core } from "../src/Core.sol";
import { MockBridge } from "../src/mocks/MockBridge.sol";
import { MockERC20 } from "../src/mocks/MockERC20.sol";
import { console } from "forge-std/console.sol";
import { BridgeConnector } from "../src/connectors/BridgeConnector.sol";

contract BridgeCallTest is BaseTest {
    MockBridge mockBridge;
    MockERC20 mockToken;

    function setUp() public override {
        super.setUp();
        mockBridge = new MockBridge();
        mockToken = new MockERC20("MockToken", "MTK");

        vm.startPrank(DEV);
        core.setBridge(address(mockBridge));
        core.createAccount(USER_TELEGRAMID);
        vm.stopPrank();

    }

    function testBridgeCall() public {
        uint256 amount = 100;
        address targetChainAddress = makeAddr("targetChainAddress");
        console.log("coreaddress", address(core));
        console.log("targetChainAddress", targetChainAddress);

        vm.expectCall(
            address(bridgeConnector),
            abi.encodeWithSelector(BridgeConnector.deposit.selector, address(mockToken), targetChainAddress, amount,address(mockBridge))
        );
        vm.startPrank(DEV);
        core.excuteBridgeCall(USER_TELEGRAMID, abi.encodeWithSelector(BridgeConnector.deposit.selector, address(mockToken), targetChainAddress, amount,address(mockBridge)));

        assertEq(mockBridge.lastToken(), address(mockToken));
        assertEq(mockBridge.lastAmount(), amount);
        assertEq(mockBridge.lastTarget(), _addressToString(targetChainAddress));
    }
}
