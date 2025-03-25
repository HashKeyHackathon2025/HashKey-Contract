// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IERC20 } from './dependencies/openzeppelin/contracts/IERC20.sol';
import { Address } from './dependencies/openzeppelin/contracts/Address.sol';
import { Initializable } from './dependencies/openzeppelin/upgradeability/Initializable.sol';

import { Errors } from './lib/Errors.sol';
import { DataTypes } from './lib/DataTypes.sol';
import { ConnectorsCall } from './lib/ConnectorsCall.sol';
import { UniversalERC20 } from './lib/UniversalERC20.sol';

import { IRouter } from './interfaces/IRouter.sol';
import { IAccount } from './interfaces/IAccount.sol';
import { IConnectors } from './interfaces/IConnectors.sol';
import { IAddressesProvider } from './interfaces/IAddressesProvider.sol';

contract Account is Initializable, IAccount {
    using UniversalERC20 for IERC20;
    using ConnectorsCall for IAddressesProvider;
    using Address for address;

    /* ============ Immutables ============ */
    IAddressesProvider public immutable ADDRESSES_PROVIDER;

    /* ============ State Variables ============ */
    address private _owner;

    /* ============ Events ============ */
    event ClaimedTokens(address token, address owner, uint256 amount);
    event BridgeSwap(address indexed fromToken, address indexed toToken, uint256 amount, uint256 receiveAmount);

    /* ============ Modifiers ============ */
    modifier onlyOwner() {
        require(_owner == msg.sender, Errors.CALLER_NOT_ACCOUNT_OWNER);
        _;
    }

    modifier onlyCallback() {
        require(msg.sender == address(this), Errors.CALLER_NOT_RECEIVER);
        _;
    }

    modifier onlyRouter() {
        require(msg.sender == address(ADDRESSES_PROVIDER.getRouter()), Errors.CALLER_NOT_ROUTER);
        _;
    }

    /* ============ Initializer ============ */
    constructor(address provider) {
        ADDRESSES_PROVIDER = IAddressesProvider(provider);
    }

    function initialize(address _user, IAddressesProvider _provider) public override initializer {
        require(ADDRESSES_PROVIDER == _provider, Errors.INVALID_ADDRESSES_PROVIDER);
        _owner = _user;
    }

    /* ============ External Functions ============ */
    function owner() public view returns (address) {
        return _owner;
    }

    function executeBridgeSwap(
        address _fromToken,
        address _toToken,
        uint256 _amount,
        string memory _targetName,
        bytes calldata _data
    ) external onlyRouter returns (uint256) {
        IERC20(_fromToken).universalTransferFrom(msg.sender, address(this), _amount);

        uint256 receiveAmount = _swap(_targetName, _data);

        emit BridgeSwap(_fromToken, _toToken, _amount, receiveAmount);
        return receiveAmount;
    }

    function claimTokens(address _token, uint256 _amount) external override onlyOwner {
        _amount = _amount == 0 ? IERC20(_token).universalBalanceOf(address(this)) : _amount;
        IERC20(_token).universalTransfer(_owner, _amount);
        emit ClaimedTokens(_token, _owner, _amount);
    }

    // solhint-disable-next-line
    receive() external payable {}

    /* ============ Private Functions ============ */
    function _swap(string memory _name, bytes memory _data) private returns (uint256 value) {
        bytes memory response = ADDRESSES_PROVIDER.connectorCall(_name, _data);
        value = abi.decode(response, (uint256));
    }

    function isConnector(string memory _name) private view returns (address) {
        address connectors = ADDRESSES_PROVIDER.getConnectors();
        require(connectors != address(0), Errors.ADDRESS_IS_ZERO);

        (bool isOk, address connector) = IConnectors(connectors).isConnector(_name);
        require(isOk, Errors.NOT_CONNECTOR);

        return connector;
    }

    function getRouter() private view returns (IRouter) {
        return IRouter(ADDRESSES_PROVIDER.getRouter());
    }
}