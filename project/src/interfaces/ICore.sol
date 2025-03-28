// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title ICore
/// @notice Interface for accessing protocol-wide configuration stored in Core
interface ICore {
    /// @notice Returns the DEX address registered in the system
    function getDex() external view returns (address);

    /// @notice Returns the Bridge address registered in the system
    function getBridge() external view returns (address);

    /// @notice Returns the Account address registered in the system
    function getAccountImpl() external view returns (address);
}
