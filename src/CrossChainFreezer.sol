// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/hyperlane-monorepo/solidity/contracts/interfaces/IMailbox.sol";
import "../lib/hyperlane-monorepo/solidity/contracts/interfaces/IMessageRecipient.sol";

/// @notice Minimal interface to call pause() on your Pausable ERC20.
interface IPausableToken {
    function pause() external;
}

contract CrossChainFreezer is IMessageRecipient {
    /// @notice Hyperlane Mailbox on *this* chain
    IMailbox public mailbox;

    /// @notice Pausable ERC20 token on *this* chain
    IPausableToken public immutable token;

    /// @notice Simple owner/guardian (can be swapped for OZ Ownable/AccessControl)
    address public owner;

    /// @notice For each origin domain, which remote freezer do we trust?
    /// originDomain => remote freezer address (as bytes32)
    mapping(uint32 => bytes32) public remoteFreezerForDomain;

    // ============ Events ============

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event RemoteFreezerSet(uint32 indexed domain, bytes32 freezer);
    event FreezeRequested(address indexed caller, uint32 indexed destDomain);
    event LocalTokenPaused(address indexed caller);
    event RemoteFreezeDispatched(
        bytes32 indexed messageId,
        uint32 indexed destDomain
    );
    event RemoteFreezeHandled(uint32 indexed origin, bytes32 indexed sender);
    event MultiFreezeRequested(address indexed caller, uint32[] destDomains);

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyMailbox() {
        require(msg.sender == address(mailbox), "not mailbox");
        _;
    }

    // ============ Constructor ============

    /// @param _mailbox Hyperlane Mailbox address on this chain
    /// @param _token Pausable ERC20 token on this chain
    constructor(address _mailbox, address _token) {
        mailbox = IMailbox(_mailbox);
        token = IPausableToken(_token);
        owner = msg.sender;
    }

    function setMailBox(IMailbox _mailbox) public returns (bool) {
        mailbox = _mailbox;
        true;
    }

    // ============ Admin ============

    function setOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "zero owner");
        emit OwnerChanged(owner, newOwner);
        owner = newOwner;
    }

    /// @notice Configure which remote freezer we trust for a given domain.
    /// Call this *after* you deploy on both chains.
    function setRemoteFreezer(
        uint32 domain,
        address freezer
    ) external onlyOwner {
        remoteFreezerForDomain[domain] = addressToBytes32(freezer);
        emit RemoteFreezerSet(domain, remoteFreezerForDomain[domain]);
    }

    // ============ SOURCE: trigger global freeze ============

    /// @notice Freeze the local token and send a freeze message to one remote domain.
    /// If you want to fan out to multiple domains, use freezeTokenAndRemoteMultiple.
    function freezeTokenAndRemote(
        uint32 destDomain
    ) external onlyOwner returns (bytes32) {
        bytes32 remote = remoteFreezerForDomain[destDomain];
        require(remote != bytes32(0), "remote freezer not set");

        emit FreezeRequested(msg.sender, destDomain);

        // 1) Pause locally
        token.pause();
        emit LocalTokenPaused(msg.sender);

        // 2) Dispatch "FREEZE" message to remote freezer on destDomain
        bytes memory body = bytes("FREEZE");

        //////////////////////////////////
        bytes32 messageId = mailbox.dispatch(destDomain, remote, body);

        emit RemoteFreezeDispatched(messageId, destDomain);
        return messageId;
    }

    /// @notice Freeze the local token and send freeze messages to multiple remote domains at once.
    /// @param destDomains Array of destination domains to freeze
    /// @return messageIds Array of message IDs for each dispatched freeze message
    function freezeTokenAndRemoteMultiple(
        uint32[] calldata destDomains
    ) external onlyOwner returns (bytes32[] memory) {
        require(destDomains.length > 0, "no domains provided");

        emit MultiFreezeRequested(msg.sender, destDomains);

        // 1) Pause locally (only once, not per domain)
        token.pause();
        emit LocalTokenPaused(msg.sender);

        // 2) Dispatch "FREEZE" messages to all remote freezers
        bytes memory body = bytes("FREEZE");
        bytes32[] memory messageIds = new bytes32[](destDomains.length);

        for (uint256 i = 0; i < destDomains.length; i++) {
            uint32 destDomain = destDomains[i];
            bytes32 remote = remoteFreezerForDomain[destDomain];
            require(remote != bytes32(0), "remote freezer not set");

            bytes32 messageId = mailbox.dispatch(destDomain, remote, body);
            messageIds[i] = messageId;

            emit RemoteFreezeDispatched(messageId, destDomain);
        }

        return messageIds;
    }

    // ============ DESTINATION: handle incoming freeze ============

    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _body
    ) external payable override onlyMailbox {
        // Check this came from the freezer we configured for that origin domain
        bytes32 expectedSender = remoteFreezerForDomain[_origin];
        require(expectedSender != bytes32(0), "unknown origin");
        require(_sender == expectedSender, "untrusted sender");

        // Check action – keep it dumb for now
        require(
            keccak256(_body) == keccak256(bytes("FREEZE")),
            "invalid action"
        );

        // Pause token on this chain
        token.pause();

        emit RemoteFreezeHandled(_origin, _sender);
    }

    // ============ Helper ============

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
