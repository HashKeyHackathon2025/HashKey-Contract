//S// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IBridge
/// @notice Interface for cross-chain token bridge
interface IBridge {
    /**
     * @notice Locks tokens into the bridge contract and emits a deposit event
     *         so that the relayer can trigger a withdrawal on the target chain.
     * @param token The address of the ERC20 token to deposit
     * @param amount The amount of tokens to deposit
     * @param targetChainAddress The recipient address on the target chain (as string)
     */
    function deposit(address token, uint256 amount, string calldata targetChainAddress) external;
}
