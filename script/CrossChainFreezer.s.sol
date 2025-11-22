// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrossChainFreezer} from "../src/CrossChainFreezer.sol";

contract CrossChainFreezerScript is Script {
    CrossChainFreezer public crossChainFreezer;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address mailBox = 0xFFd955E593139E3Dd40d9517E291b429f20EA5e7;
        address token = 0xE3347DC25e96F65E0029B18595bCAf6656Ed027e;

        // uint32 localDomain = 1918988905;

        crossChainFreezer = new CrossChainFreezer(mailBox, token);

        vm.stopBroadcast();
    }
}
