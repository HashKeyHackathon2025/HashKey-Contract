// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Proxy} from './Proxy.sol';
import { IAddressesProvider } from './interfaces/IAddressesProvider.sol';
import { IAccount } from './interfaces/IAccount.sol';

contract AAWalletFactory {
    IAddressesProvider public immutable ADDRESSES_PROVIDER;

    mapping(uint256 => address) public walletByTelegramId;
    mapping(address => uint256) public telegramIdByWallet;

    event WalletCreated(uint256 telegramId, address wallet);

    constructor(address _provider) { 
        ADDRESSES_PROVIDER = IAddressesProvider(_provider);
    }

    function createWallet(uint256 _telegramId) external returns (address) {
        require(walletByTelegramId[_telegramId] == address(0), "Wallet already exists");

        Proxy wallet = new Proxy(address(ADDRESSES_PROVIDER));

        IAccount(address(wallet)).initialize(msg.sender, ADDRESSES_PROVIDER);

        walletByTelegramId[_telegramId] = address(wallet);
        telegramIdByWallet[address(wallet)] = _telegramId;

        emit WalletCreated(_telegramId, address(wallet));
        return address(wallet);
    }

    function getWalletAddress(uint256 _telegramId) external view returns (address) {
        return walletByTelegramId[_telegramId];
    }
}