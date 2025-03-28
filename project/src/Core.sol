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
    event DEXSet(address dex);
    event BridgeSet(address bridge);

    // ─────────────── Constants ───────────────
    bytes32 public constant DEX = keccak256("DEX");
    bytes32 public constant BRIDGE = keccak256("BRIDGE");

    // ─────────────── State Variables ───────────────
    mapping(uint256 => address) public accountByTelegramId;
    mapping(address => uint256) public telegramIdByAccount;
    mapping(bytes32 => address) private _connectors;

    address public ACCOUNT_IMPL;
    address public connector;

    // ─────────────── Constructor ───────────────
    constructor(address _accountImpl) {
        require(_accountImpl != address(0), Errors.INVALID_ADDRESS);
        ACCOUNT_IMPL = _accountImpl;
    }

    // ─────────────── External Functions ───────────────
    function setDEX(address _dex) external onlyOwner {
        require(_dex != address(0), Errors.INVALID_ADDRESS);
        _connectors[DEX] = _dex;
        emit DEXSet(_dex);
    }

    function setBridge(address _bridge) external onlyOwner {
        require(_bridge != address(0), Errors.INVALID_ADDRESS);
        _connectors[BRIDGE] = _bridge;
        emit BridgeSet(_bridge);
    }

    function createAccount(uint256 _telegramId) external onlyOwner returns (address){
        require(accountByTelegramId[_telegramId] == address(0), Errors.WALLET_ALREADY_EXISTS);

        address dex = _connectors[DEX];
        address bridge = _connectors[BRIDGE];
        require(dex != address(0) && bridge != address(0), Errors.INVALID_ADDRESS);

        address account = LibClone.cloneDeterministic(ACCOUNT_IMPL, keccak256(abi.encodePacked(_telegramId)));
        IAccount(account).initialize(address(this));

        accountByTelegramId[_telegramId] = account;
        telegramIdByAccount[account] = _telegramId;

        return account;
    }

    function getAccountAddress(uint256 _telegramId) external view onlyOwner returns (address) {
        return accountByTelegramId[_telegramId];
    }

    function getDex() external view returns (address) {
        return _connectors[DEX];
    }

    function getBridge() external view returns (address) {
        return _connectors[BRIDGE];
    }

    function getAccountImpl() external view returns (address) {
        return ACCOUNT_IMPL;
    }
}
