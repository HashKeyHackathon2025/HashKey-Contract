// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

import { Errors } from "../lib/Errors.sol";
import { ICore } from "../interfaces/ICore.sol";
import { console } from "forge-std/console.sol";
import { IBridge } from "../interfaces/IBridge.sol";

contract BridgeConnector {

    // ─────────────── External Functions ───────────────
    function deposit(address token, address toAccount, uint256 amount, address bridge) external {
        string memory targetChainAddress = _addressToString(toAccount);
        console.log("toAccount: %s", toAccount);
        console.log("targetChainAddress: %s", targetChainAddress);
        IBridge(bridge).deposit(token, amount, targetChainAddress);
    }

    // ─────────────── Internal Functions ───────────────
    function _addressToString(address _addr) internal pure returns (string memory) {
        bytes20 value = bytes20(_addr);
        bytes memory characters = "0123456789abcdef";
        bytes memory str = new bytes(42); // "0x" + 40 hex chars

        str[0] = '0';
        str[1] = 'x';

        for (uint i = 0; i < 20; i++) {
            str[2 + i * 2] = characters[uint8(value[i] >> 4)];
            str[3 + i * 2] = characters[uint8(value[i] & 0x0f)];
        }

        return string(str);
    }
}
