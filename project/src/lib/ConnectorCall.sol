// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Errors } from "./Errors.sol";

library ConnectorCall {
    /**
     * @dev Delegates the current call to `target`.
     * @param _target Address of the connector.
     * @param _data Execute calldata.
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _delegatecall(address _target, bytes memory _data) internal returns (bytes memory response) {
        require(_target != address(0), Errors.INVALID_ADDRESS);
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let succeeded := delegatecall(gas(), _target, add(_data, 0x20), mload(_data), 0, 0)
            let size := returndatasize()

            response := mload(0x40)
            mstore(0x40, add(response, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            mstore(response, size)
            returndatacopy(add(response, 0x20), 0, size)

            switch iszero(succeeded)
            case 1 {
                // throw if delegatecall failed
                returndatacopy(0x00, 0x00, size)
                revert(0x00, size)
            }
        }
    }
}
