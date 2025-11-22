// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.8.0;

import {IPostDispatchHook} from "../lib/hyperlane-monorepo/solidity/contracts/interfaces/hooks/IPostDispatchHook.sol";

contract NoOpHook is IPostDispatchHook {
    /// @notice Identifies the hook type. For a no-op we can just return 0.
    function hookType() external pure override returns (uint8) {
        return 0;
    }

    /// @notice Called by the Mailbox after dispatch. Does nothing and accepts ETH.
    function postDispatch(
        bytes calldata, /* metadata */
        bytes calldata  /* message */
    ) external payable override {
        // no-op
    }

    /// @notice Always returns 0, meaning no extra fee is required.
    function quoteDispatch(
        bytes calldata, /* metadata */
        bytes calldata  /* message */
    ) external pure override returns (uint256) {
        return 0;
    }

    /// @notice We accept any metadata format (or none).
    function supportsMetadata(
        bytes calldata /* metadata */
    ) external pure override returns (bool) {
        return true;
    }
}
