// SPDX-License-Identifier: UNLICENSED
import {Test, console2} from "forge-std/Test.sol";
import {DaovationEvent} from "../../src/event/DaovationEvent.sol";
import {SafeHelper} from "./SafeHelper.t.sol";

pragma solidity ^0.8.19;

contract DeployHelper is Test {
    AppEvent public appEvent;
    DaovationEvent public daovationContract;
    SafeHelper public safeHelper;

    address masterCopy = safeHelper.safeMasterCopy();
    address safeFactory = address(safeHelper.safeFactory());

    address safeAddr;

    function deployAllContracts() public {
        safeHelper = new SafeHelper();
        safeAddr = safeHelper.setupSafeEnv();
        appEvent = new AppEvent();

        daovationContract = new DaovationEvent(masterCopy, safeFactory, address(appEvent));
    }
}