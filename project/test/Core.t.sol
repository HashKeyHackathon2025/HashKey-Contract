// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Test } from "forge-std/Test.sol";
import { Core } from "../src/Core.sol";
import { AccountImpl } from "../src/AccountImpl.sol";
import { IAccount } from "../src/interfaces/IAccount.sol";
import { Errors } from "../src/lib/Errors.sol";


contract CoreTest is Test {
    event AccountCreated(uint256 telegramId, address wallet);

    Core core;
    AccountImpl accountImpl;

    address public DEV = makeAddr("DEV");
    address public DEX = makeAddr("DEX");
    address public BRIDGE = makeAddr("BRIDGE");

    address public USER = makeAddr("USER");
    uint256 public USER_TELEGRAMID = 123456789;

    function setUp() public {
        vm.prank(DEV);
        accountImpl = new AccountImpl();

        vm.prank(DEV);
        core = new Core(address(accountImpl));

        vm.startPrank(DEV);
        core.setDEX(DEX);
        core.setBridge(BRIDGE);
        vm.stopPrank();
    }

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
