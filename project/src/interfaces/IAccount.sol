// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IAccount {
    /// @notice Initializes the account with owner and core address
    function initialize(address owner, address core) external;

    /// @notice Returns the account owner
    function owner() external view returns (address);

    /// @notice Returns the assigned user address
    function user() external view returns (address);

    /// @notice Sets the user address
    function setUser(address newUser) external;

    /// @notice Executes a bridge deposit via bridge from core
    /// @param token The ERC20 token to deposit
    /// @param amount The amount to deposit
    /// @param targetChainAddress The target chain recipient address (string format)
    /// @return The amount deposited
    function executeBridgeDeposit(
        address token,
        uint256 amount,
        string calldata targetChainAddress
    ) external returns (uint256);

    /// @notice Executes a swap via DEX from core
    /// @param fromToken The input token
    /// @param toToken The output token
    /// @param amount The amount to swap
    /// @param data Encoded swap parameters for the DEX
    /// @return The amount received from the swap
    function executeSwap(
        address fromToken,
        address toToken,
        uint256 amount,
        bytes calldata data
    ) external returns (uint256);

    /// @notice Claims tokens from this account to the assigned user
    /// @param token The token address
    /// @param amount The amount to claim (0 means full balance)
    function claimTokens(address token, uint256 amount) external;
}
