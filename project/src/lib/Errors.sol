// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Errors library
 * @author zRex
 * @notice Defines the error messages emitted by the different contracts of the zRex protocol
 */
library Errors {
    // The ADDRESS IS INVALID
    string public constant INVALID_ADDRESS = '0';
    // The USER IS NOT SET
    string public constant USER_NOT_SET = '1';
    // The CALLER IS NOT THE OWNER
    string public constant CALLER_NOT_OWNER = '2';
    // The CALLER IS NOT THE USER
    string public constant CALLER_NOT_USER = '3';
    // The CALLER IS NOT THE RECEIVER
    string public constant CALLER_NOT_RECEIVER = '4';
    // The WALLET ALREADY EXISTS
    string public constant WALLET_ALREADY_EXISTS = '5';
    // The CALLER IS NOT THE ACCOUNT OWNER
    string public constant CALLER_NOT_ACCOUNT_OWNER = '6';
    // The CALLER IS NOT THE ACCOUNT USER
    string public constant CALLER_NOT_ACCOUNT_USER = '7';
    // The CALLER IS NOT THE ACCOUNT RECEIVER
    string public constant INVALID_USER = '8';
    // The ADDRES IS ZERO
    string public constant ZERO_ADDRESS = '9';
    // The IMPLEMENTATION ADDRESS IS INVALID
    string public constant INVALID_IMPLEMENTATION_ADDRESS = '10';
    // The TELEGRAM ID IS INVALID
    string public constant INVALID_TELEGRAM_ID = '11';
}
