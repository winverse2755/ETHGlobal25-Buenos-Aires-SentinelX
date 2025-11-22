// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TrustedRelayerIsm} from "../lib/hyperlane-monorepo/solidity/contracts/isms/TrustedRelayerIsm.sol";

contract TrustedRelayerIsmScript is Script {
    TrustedRelayerIsm public trustedRelayerIsm;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address mailBox = 0x8df6307f003Cd31c12560332b6eb1EE0278d9329;
        address relayer = 0x0aEDc81C6946f8867dD5a5437A1346a35CdC3928;

        trustedRelayerIsm = new TrustedRelayerIsm(mailBox, relayer);

        vm.stopBroadcast();
    }
}
