// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/hyperlane-monorepo/solidity/contracts/interfaces/IMailbox.sol";
import "../lib/hyperlane-monorepo/solidity/contracts/interfaces/IMessageRecipient.sol";

contract MailBoxTestCall {
    uint256 public number = 2;

    // Rari testnet mailbox address
    address constant mailboxAddress =
        0xb0bb23B185A7Ba519426C038DEcAFaB4D0a9055b;

    uint32 public nonce;

    function getNonce() public {
        IMailbox mailbox = IMailbox(mailboxAddress);
        nonce = mailbox.localDomain();
        number = 4;
    }

    function sendMessage(
        address appDestinationAddress
    ) public returns (bytes32) {
        // Appchain ID
        uint32 destinationChainId = 4661;

        IMailbox mailbox = IMailbox(mailboxAddress);
        bytes32 appDestinationAddressBytes32 = addressToBytes32(
            appDestinationAddress
        );
        bytes32 messageId = mailbox.dispatch(
            destinationChainId,
            appDestinationAddressBytes32,
            bytes("Hello, world")
        );

        return messageId;
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
