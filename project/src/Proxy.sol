// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ICore } from './interfaces/ICore.sol';
import { Errors } from './lib/Errors.sol';

contract Proxy {
    // The contract by which all other contact addresses are obtained.
    ICore public immutable CORE;

    constructor(address _core) {
        CORE = ICore(_core);
    }

    /**
     * @dev Delegates the current call to `implementation`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _delegate(address implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    /**
     * @dev Delegates the current call to the address returned by `getImplementation()`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _fallback() internal {
        address _implementation = CORE.getAccountImpl();
        require(_implementation != address(0), Errors.INVALID_IMPLEMENTATION_ADDRESS);
        _delegate(_implementation);
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `getImplementation()`.
     * Will run if no other function in the contract matches the call data.
     */
    fallback() external payable {
        _fallback();
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `getImplementation()`.
     * Will run if call data is empty.
     */
    receive() external payable {
        _fallback();
    }
}