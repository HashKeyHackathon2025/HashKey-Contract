// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// ─────────────── External Imports ───────────────
import { Initializable } from "solady/utils/Initializable.sol";
import { LibClone } from "solady/utils/LibClone.sol";

// ─────────────── Internal Imports ───────────────
import { Ownable } from "./dependencies/openzeppelin/contracts/Ownable.sol";
import { Clones } from "./dependencies/openzeppelin/upgradeability/Clones.sol";
import { IAccount } from "./interfaces/IAccount.sol";
import { ICore } from "./interfaces/ICore.sol";
import { Errors } from "./lib/Errors.sol";

// ────────────────────────────────────────────────
contract Core is Ownable, Initializable, ICore {
    using Clones for address;

    // ─────────────── Events ───────────────
    event WalletCreated(uint256 telegramId, address wallet);
    event DEXSet(address dex);
    event BridgeSet(address bridge);

    // ─────────────── Constants ───────────────
    bytes32 public constant DEX = keccak256("DEX");
    bytes32 public constant BRIDGE = keccak256("BRIDGE");

    // ─────────────── State Variables ───────────────
    mapping(uint256 => address) public walletByTelegramId;
    mapping(address => uint256) public telegramIdByWallet;
    mapping(bytes32 => address) private _registry;

    address public ACCOUNT_IMPL;
    address public connector;
    address public immutable accountImplementation;

    // ─────────────── Constructor ───────────────
    constructor(address _accountImplementation) Ownable() {
        require(_accountImplementation != address(0), Errors.INVALID_ADDRESS);
        accountImplementation = _accountImplementation;
    }

    // ─────────────── External Functions ───────────────
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

    function createWallet(uint256 _telegramId) external onlyOwner {
        require(walletByTelegramId[_telegramId] == address(0), Errors.WALLET_ALREADY_EXISTS);

        address dex = _registry[DEX];
        address bridge = _registry[BRIDGE];
        require(dex != address(0) && bridge != address(0), Errors.INVALID_ADDRESS);

        address account = LibClone.cloneDeterministic(ACCOUNT_IMPL, keccak256(abi.encodePacked(_telegramId)));
        IAccount(account).initialize(address(this));

        emit WalletCreated(_telegramId, account);
    }

    function initialize(address accountImpl) external initializer {
        require(accountImpl != address(0), Errors.INVALID_ADDRESS);
        ACCOUNT_IMPL = accountImpl;
    }

    function getWalletAddress(uint256 _telegramId) external view onlyOwner returns (address) {
        return walletByTelegramId[_telegramId];
    }

    function getDex() external view returns (address) {
        return _registry[DEX];
    }

    function getBridge() external view returns (address) {
        return _registry[BRIDGE];
    }

    function getAccountImpl() external view returns (address) {
        return ACCOUNT_IMPL;
    }

    function getConnector() external view returns (address) {
        return connector;
    }

    function setConnector(address _connector) external onlyOwner {
        require(_connector != address(0), Errors.INVALID_ADDRESS);
        connector = _connector;
    }
    
}
