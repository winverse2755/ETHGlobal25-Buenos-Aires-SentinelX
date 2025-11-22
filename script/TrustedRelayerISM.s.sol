// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TrustedRelayerIsm} from "../lib/hyperlane-monorepo/solidity/contracts/isms/TrustedRelayerIsm.sol";

contract TrustedRelayerIsmScript is Script {
    TrustedRelayerIsm public trustedRelayerIsm;

    function setUp() public {}

    function run() public {
        

        trustedRelayerIsm = new TrustedRelayerIsm(mailBox, relayer);

        vm.stopBroadcast();
    }
}
