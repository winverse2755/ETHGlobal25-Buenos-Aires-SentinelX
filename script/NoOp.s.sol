// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NoOpHook} from "../src/NoOpHook.sol";

contract NoOpHookScript is Script {
    NoOpHook public noOpHook;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        noOpHook = new NoOpHook();

        vm.stopBroadcast();
    }
}
