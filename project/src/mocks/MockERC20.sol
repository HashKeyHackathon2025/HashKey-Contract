// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// ─────────────── External Imports ───────────────
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// ────────────────────────────────────────────────
contract MockERC20 is ERC20 {
    // ─────────────── Constructor ───────────────
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    // ─────────────── Minting Function (for testing) ───────────────
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
