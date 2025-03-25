// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAddressesProvider } from './IAddressesProvider.sol';

interface IAccount {
    function initialize(address _user, IAddressesProvider _provider) external;

    function executeBridgeSwap(
        address _fromToken,
        address _toToken,
        uint256 _amount,
        string memory _targetName,
        bytes calldata _data
    ) external returns (uint256);

    function claimTokens(address _token, uint256 _amount) external;
}