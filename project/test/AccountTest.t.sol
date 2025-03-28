// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { BaseTest } from "./BaseTest.t.sol";
import { AccountImpl } from "../src/AccountImpl.sol";
import { Core } from "../src/Core.sol";
import { Errors } from "../src/lib/Errors.sol";
import { MockERC20 } from "../src/mocks/MockERC20.sol";

contract AccountTest is BaseTest {
    function setUp() public override {
        super.setUp();

        vm.startPrank(DEV);
        accountImpl = new AccountImpl();
        core = new Core(address(accountImpl));

        core.setDEX(DEX);
        core.setBridge(BRIDGE);

        core.createAccount(USER_TELEGRAMID);
        vm.stopPrank();
    }

    function testInitialOwnerIsCore() public view {
        address account = core.accountByTelegramId(USER_TELEGRAMID);
        assertEq(AccountImpl(payable(account)).owner(), address(core));
    }

    function testSetUser() public {
        address userEOA = makeAddr("userEOA");
        address account = core.accountByTelegramId(USER_TELEGRAMID);

        // Set user via core (onlyOwner)
        vm.prank(DEV);
        core.setAccountUser(USER_TELEGRAMID, userEOA);

        // Check that AccountImpl reflects the user
        assertEq(AccountImpl(payable(account)).user(), userEOA);
    }

    function testClaimTokens() public {
        address userEOA = makeAddr("UserEOA");
        address account = core.accountByTelegramId(USER_TELEGRAMID);

        MockERC20 mockToken = new MockERC20("MockToken", "MTK");
        mockToken.mint(account, 1_000 ether);

        vm.prank(DEV);
        core.setAccountUser(USER_TELEGRAMID, userEOA);

        assertEq(mockToken.balanceOf(userEOA), 0);

        vm.prank(userEOA);
        AccountImpl(payable(account)).claimTokens(address(mockToken), 0);

        assertEq(mockToken.balanceOf(userEOA), 1_000 ether);
        assertEq(mockToken.balanceOf(account), 0);
    }

}