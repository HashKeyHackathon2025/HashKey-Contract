// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Test } from "forge-std/Test.sol";
import { Core } from "../src/Core.sol";
import { AccountImpl } from "../src/AccountImpl.sol";
import { IAccount } from "../src/interfaces/IAccount.sol";
import { Errors } from "../src/lib/Errors.sol";
import { BridgeConnector } from "../src/connectors/BridgeConnector.sol";


contract BaseTest is Test {
    event AccountCreated(uint256 telegramId, address wallet);

    Core core;
    AccountImpl accountImpl;
    BridgeConnector bridgeConnector;

    address public DEV = makeAddr("DEV");
    address public DEX = makeAddr("DEX");
    address public BRIDGE = makeAddr("BRIDGE");

    address public USER = makeAddr("USER");
    uint256 public USER_TELEGRAMID = 123456789;

    function setUp() public virtual{
        vm.prank(DEV);
        accountImpl = new AccountImpl();

        vm.prank(DEV);
        core = new Core(address(accountImpl));

        vm.prank(DEV);
        bridgeConnector = new BridgeConnector();

        vm.startPrank(DEV);
        core.setDEX(DEX);
        core.setBridge(BRIDGE);
        core.setBridgeConnector(address(bridgeConnector));
        vm.stopPrank();
    }

    // ─────────────── Internal Functions ───────────────
    function _addressToString(address _addr) internal pure returns (string memory) {
        bytes20 value = bytes20(_addr);
        bytes memory characters = "0123456789abcdef";
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';

        for (uint i = 0; i < 20; i++) {
            str[2 + i * 2] = characters[uint8(value[i] >> 4)];
            str[3 + i * 2] = characters[uint8(value[i] & 0x0f)];
        }

        return string(str);
    }
}
