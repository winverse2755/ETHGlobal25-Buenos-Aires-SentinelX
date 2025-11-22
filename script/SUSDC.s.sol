// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SampleUSDC} from "../src/SampleUSDC.sol";

contract SampleUSDCScript is Script {
    SampleUSDC public sampleUSDC;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address recipient = 0x0aEDc81C6946f8867dD5a5437A1346a35CdC3928;
        address defaultAdmin = 0x0aEDc81C6946f8867dD5a5437A1346a35CdC3928;
        address pauser = 0x0aEDc81C6946f8867dD5a5437A1346a35CdC3928;
        address minter = 0x0aEDc81C6946f8867dD5a5437A1346a35CdC3928;

        uint32 localDomain = 1918988905;

        sampleUSDC = new SampleUSDC(recipient, defaultAdmin, pauser, minter);

        vm.stopBroadcast();
    }
}
