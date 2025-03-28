// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { BaseTest } from "./BaseTest.t.sol";


contract CoreTest is BaseTest {
    function testCoreDeployed() public view {
        assertEq(core.owner(), DEV);
        assertEq(core.getAccountImpl(), address(accountImpl));
    }

    function testGetterSetter() public {
        address newDex=makeAddr("NEWDEX");
        address newBridge=makeAddr("NEWBRIDGE");

        assertEq(core.getDex(), DEX);
        vm.prank(DEV);
        core.setDEX(newDex);
        assertEq(core.getDex(), newDex);

        assertEq(core.getBridge(), BRIDGE);
        vm.prank(DEV);
        core.setBridge(newBridge);
        assertEq(core.getBridge(), newBridge);
    }

    function testCreateAccount() public {
        vm.prank(DEV);
        address created = core.createAccount(USER_TELEGRAMID);
        address created2 = core.accountByTelegramId(USER_TELEGRAMID);
        assertEq(created , created2);
    }
}
