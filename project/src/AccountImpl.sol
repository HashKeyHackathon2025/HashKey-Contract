// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// ─────────────── External Imports ───────────────
import { IERC20 } from "./dependencies/openzeppelin/contracts/IERC20.sol";
import { Address } from "./dependencies/openzeppelin/contracts/Address.sol";
import { Initializable } from "./dependencies/openzeppelin/upgradeability/Initializable.sol";

// ─────────────── Internal Imports ───────────────
import { Errors } from "./lib/Errors.sol";
import { ConnectorCall } from "./lib/ConnectorCall.sol";
import { IAccount } from "./interfaces/IAccount.sol";
import { ICore } from "./interfaces/ICore.sol";

// ────────────────────────────────────────────────
contract AccountImpl is Initializable, IAccount {
    using ConnectorCall for address;
    using Address for address;

    // ─────────────── Events ───────────────
    event ClaimedTokens(address token, address owner, uint256 amount);
    event UserSet(address user);

    // ─────────────── State Variables ───────────────
    address private _owner;
    address private _user;
    address private _core;

    // ─────────────── Modifiers ───────────────
    modifier onlyOwner() {
        require(_owner == msg.sender, Errors.CALLER_NOT_ACCOUNT_OWNER);
        _;
    }

    modifier onlyUser() {
        require(_user == msg.sender, Errors.CALLER_NOT_ACCOUNT_USER);
        _;
    }

    modifier onlyCallback() {
        require(msg.sender == address(this), Errors.CALLER_NOT_RECEIVER);
        _;
    }

    // ─────────────── Initializer ───────────────
    function initialize(address newOwner) public initializer {
        require(newOwner != address(0), Errors.INVALID_ADDRESS);
        _owner = newOwner;
    }

    // ─────────────── External/Public Functions ───────────────
    function owner() public view returns (address) {
        return _owner;
    }

    function user() public view returns (address) {
        return _user;
    }

    function setUser(address _newUser) external onlyOwner {
        require(_newUser != address(0), Errors.INVALID_USER);
        _user = _newUser;
        emit UserSet(_newUser);
    }

    // function executeBridgeDeposit(
    //     address token,
    //     uint256 amount,
    //     string calldata targetChainAddress
    // ) external onlyOwner returns (uint256) {
    //     address bridge = ICore(_core).getBridge();
    //     IERC20(token).universalApprove(bridge, amount);
    //     IBridge(bridge).deposit(token, amount, targetChainAddress);
    //     return amount;
    // }

    // function executeSwap(
    //     address fromToken,
    //     address toToken,
    //     uint256 amount,
    //     bytes calldata data
    // ) external onlyOwner returns (uint256) {
    //     address dex = ICore(_core).getDex();
    //     IERC20(fromToken).universalApprove(dex, amount);
    //     IDEX(dex).swap(fromToken, toToken, amount);
    //     emit BridgeSwap(fromToken, toToken, amount);
    //     return amount;
    // }

    function claimTokens(address _token, uint256 _amount) external override onlyUser {
        require(_user != address(0), Errors.USER_NOT_SET);
        uint256 amount = _amount == 0
            ? IERC20(_token).balanceOf(address(this))
            : _amount;
        IERC20(_token).transfer(_user, amount);
        emit ClaimedTokens(_token, _owner, amount);
    }

    function connectorCall(address connector, bytes memory data) external onlyOwner returns (bytes memory) {
        require(connector != address(0) , Errors.INVALID_ADDRESS);

        return connector._delegatecall(data);
    }

    // ─────────────── Fallback ───────────────
    // solhint-disable-next-line
    receive() external payable {}
}
