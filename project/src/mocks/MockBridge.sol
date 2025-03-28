// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// ─────────────── Internal Imports ───────────────
import { IBridge } from "../interfaces/IBridge.sol";

// ────────────────────────────────────────────────
contract MockBridge is IBridge {
    // ─────────────── Events ───────────────
    event MockDeposit(address indexed token, uint256 amount, string targetChainAddress);

    // ─────────────── State Variables ───────────────
    address public lastToken;
    uint256 public lastAmount;
    string public lastTarget;

    // ─────────────── External Functions ───────────────
    function deposit(address token, uint256 amount, string calldata targetChainAddress) external override {
        lastToken = token;
        lastAmount = amount;
        lastTarget = targetChainAddress;

        emit MockDeposit(token, amount, targetChainAddress);
    }
}
