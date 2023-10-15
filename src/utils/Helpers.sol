// SPDX-License-Identifier: UNLICENSED
import {
    IGnosisSafe,
    IGnosisSafeProxy
} from "./../interfaces/GnosisSafeInterfaces.sol";
import {Constants} from "./constants.sol";
import {AppEventVariables} from "./../event/AppEventVariables.sol";

pragma solidity ^0.8.19;

abstract contract Helpers is Constants, AppEventVariables {
    modifier validAddress(address _to) {
        if (_to == address(0) || _to == SENTINEL_ADDRESS) {
            revert InvalidAddressProvided(_to);
        }
        _;
    }

    // modifier isSafeContract(address _safe) {
    //     if (_safe == address(0) || _safe == SENTINEL_ADDRESS || !isSafe(_safe))
    //     {
    //         revert InvalidGnosisSafe(_safe);
    //     }
    //     _;
    // }

    function internalEnableModule(address _module)
        external
        validAddress(_module)
    {
        this.enableModule(_module);
    }
}
