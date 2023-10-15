// SPDX-License-Identifier: UNLICENSED
import {Test, console2} from "forge-std/Test.sol";
import {DaovationEvent} from "../src/event/DaovationEvent.sol";
import {SafeHelper} from "./helpers/SafeHelper.t.sol";

pragma solidity ^0.8.19;

contract DaovationEventTest is Test {
    DaovationEvent public daovationContract;
    SafeHelper public safeHelper;

    address masterCopy = safeHelper.gnosisMasterCopy();
    address safeFactory = address(safeHelper.safeFactory());

    address safeAddr;

    function setUp() public {
        safeHelper = new SafeHelper();
        safeAddr = safeHelper.setupSafeEnv();

        daovationContract = new DaovationEvent(masterCopy, safeFactory);
    }
}
