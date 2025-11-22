// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MailBoxTestCall} from "../src/MailBoxTestCall.sol";

contract MailBoxTestCallScript is Script {
    MailBoxTestCall public mailBoxTestCall;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        mailBoxTestCall = new MailBoxTestCall();

        mailBoxTestCall.getNonce();

        vm.stopBroadcast();
    }
}
