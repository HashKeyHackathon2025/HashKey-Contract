// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IAccount {
    /// @notice Initializes the account with owner and core address
    function initialize(address owner) external;

    /// @notice Returns the account owner
    function owner() external view returns (address);

    /// @notice Returns the assigned user address
    function user() external view returns (address);

    /// @notice Sets the user address
    function setUser(address newUser) external;

    /// @notice Claims tokens from this account to the assigned user
    /// @param token The token address
    /// @param amount The amount to claim (0 means full balance)
    function claimTokens(address token, uint256 amount) external;

    /**
     * @notice Executes a delegatecall to a specified connector contract with provided data.
     * @param connector The address of the contract to delegatecall.
     * @param data The calldata sent to the connector.
     * @return The result of the delegatecall.
     */
    function connectorCall(address connector, bytes memory data) external returns (bytes memory);
}
