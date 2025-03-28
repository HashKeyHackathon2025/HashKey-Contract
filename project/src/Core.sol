// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Ownable } from './dependencies/openzeppelin/contracts/Ownable.sol';
import { IAccount } from './interfaces/IAccount.sol';
import { Errors } from './lib/Errors.sol';
import { Clones } from './dependencies/openzeppelin/upgradeability/Clones.sol';

contract Core is Ownable {
    using Clones for address;

    mapping(uint256 => address) public walletByTelegramId;
    mapping(address => uint256) public telegramIdByWallet;
    mapping(bytes32 => address) private _registry;

    bytes32 public constant DEX = keccak256("DEX");
    bytes32 public constant BRIDGE = keccak256("BRIDGE");

    address public immutable accountImplementation;

    event WalletCreated(uint256 telegramId, address wallet);
    event DEXSet(address dex);
    event BridgeSet(address bridge);

    constructor(address _accountImplementation) Ownable() {
        require(_accountImplementation != address(0), Errors.INVALID_ADDRESS);
        accountImplementation = _accountImplementation;
    }

    function setDEX(address _dex) external onlyOwner {
        require(_dex != address(0), Errors.INVALID_ADDRESS);
        _registry[DEX] = _dex;
        emit DEXSet(_dex);
    }

    function setBridge(address _bridge) external onlyOwner {
        require(_bridge != address(0), Errors.INVALID_ADDRESS);
        _registry[BRIDGE] = _bridge;
        emit BridgeSet(_bridge);
    }

    function getDex() external view returns (address) {
        return _registry[DEX];
    }

    function getBridge() external view returns (address) {
        return _registry[BRIDGE];
    }

    function createWallet(uint256 _telegramId) external onlyOwner returns (address) {
        require(walletByTelegramId[_telegramId] == address(0), Errors.WALLET_ALREADY_EXISTS);

        address dex = _registry[DEX];
        address bridge = _registry[BRIDGE];
        require(dex != address(0) && bridge != address(0), Errors.INVALID_ADDRESS);

        address clone = accountImplementation.clone();
        IAccount(clone).initialize(msg.sender, address(this));

        walletByTelegramId[_telegramId] = clone;
        telegramIdByWallet[clone] = _telegramId;

        emit WalletCreated(_telegramId, clone);
        return clone;
    }

    function getWalletAddress(uint256 _telegramId) external view onlyOwner returns (address) {
        return walletByTelegramId[_telegramId];
    }
}
