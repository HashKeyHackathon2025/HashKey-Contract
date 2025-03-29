// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ICore {
    /**
     * @notice Returns the connector address registered for DEX
     */
    function getDexConnector() external view returns (address);

    /**
     * @notice Returns the connector address registered for Bridge
     */
    function getBridgeConnector() external view returns (address);

    /**
     * @notice Returns the DEX contract address
     */
    function getDex() external view returns (address);

    /**
     * @notice Returns the Bridge contract address
     */
    function getBridge() external view returns (address);

    /**
     * @notice Returns the account implementation contract address
     */
    function getAccountImpl() external view returns (address);

    /**
     * @notice Returns the deployed account address by Telegram ID
     * @param _telegramId Telegram ID of the user
     */
    function getAccountAddress(uint256 _telegramId) external view returns (address);

    /**
     * @notice Creates a new account for a Telegram ID
     * @param _telegramId The user's Telegram ID
     * @return The deployed account address
     */
    function createAccount(uint256 _telegramId) external returns (address);

    /**
     * @notice Executes a bridge call on behalf of the Telegram user
     * @param telegramId Telegram ID associated with the user account
     * @param _data Encoded calldata to be passed to the bridge connector
     */
    function excuteBridgeCall(uint256 telegramId, bytes memory _data) external;

    /**
     * @notice Executes a DEX call on behalf of the Telegram user
     * @param telegramId Telegram ID associated with the user account
     * @param _data Encoded calldata to be passed to the DEX connector
     */
    function excuteDexCall(uint256 telegramId, bytes memory _data) external;

    /**
     * @notice Sets the user address for a specific Telegram account
     * @param telegramId Telegram ID of the account
     * @param user The new user EOA to assign
     */
    function setAccountUser(uint256 telegramId, address user) external;
}
