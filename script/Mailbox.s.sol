// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Mailbox} from "../lib/hyperlane-monorepo/solidity/contracts/Mailbox.sol";

contract MailBoxScript is Script {
    Mailbox public mailBox;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        uint32 localDomain = 11142220;

        mailBox = new Mailbox(localDomain);

        vm.stopBroadcast();
    }
}
