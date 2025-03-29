// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IBridge
/// @notice Interface for cross-chain bridge deposit functionality
interface IBridge {
    /**
     * @notice Initiates a bridge transfer to another chain
     * @param token The ERC20 token address to bridge
     * @param amount The amount of tokens to bridge
     * @param targetChainAddress The target chain recipient address, in string format (e.g. "0xabc..." or encoded)
     */
    function deposit(address token, uint256 amount, string calldata targetChainAddress) external;
}
