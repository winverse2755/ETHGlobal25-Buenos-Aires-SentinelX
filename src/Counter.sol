// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/hyperlane-monorepo/solidity/contracts/interfaces/IMailbox.sol";
import "../lib/hyperlane-monorepo/solidity/contracts/interfaces/IMessageRecipient.sol";

contract Counter {
    uint256 public number;

    // Rari testnet mailbox address
    address constant mailboxAddress = 0x8df6307f003Cd31c12560332b6eb1EE0278d9329;
    // Appchain testnet mailbox address
    address constant mailboxAddressDestination = 0xCc9777854a223EC841106991CAD287195df15F6D;

    // --------------- SOURCE: Logic for sending message ---------------
    function sendMessage(address appDestinationAddress) public returns (bytes32) {
        // Appchain ID
        uint32 destinationChainId = 4661;

        IMailbox mailbox = IMailbox(mailboxAddress);
        bytes32 appDestinationAddressBytes32 = addressToBytes32(appDestinationAddress);
        bytes32 messageId = mailbox.dispatch(destinationChainId, appDestinationAddressBytes32, bytes("Hello, world"));

        return messageId;
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

    // --------------- DESTINATION: Logic for receiving a message ----------------------
    modifier onlyMailbox() {
        require(msg.sender == mailboxAddressDestination);
        _;
    }

    function handle(uint32 _origin, bytes32 _sender, bytes calldata _body) external onlyMailbox {
        // Just increment the local counter when receiving the message
        number++;
    }
}