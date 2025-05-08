// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.24;

import {IChildToken} from "./IChildToken.sol";
import {Pool} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Pool.sol";
import {TokenPool} from "@chainlink/contracts-ccip/src/v0.8/ccip/pools/TokenPool.sol";

abstract contract CustomBurnMintTokenPoolAbstract is TokenPool {
    /// @notice Contains the specific burn call for a pool.
    /// @dev overriding this method allows us to create pools with different burn signatures
    /// without duplicating the underlying logic.
    function _burn(uint256 amount) internal virtual;

    /// @notice Burn the token in the pool
    /// @dev The _validateLockOrBurn check is an essential security check
    function lockOrBurn(Pool.LockOrBurnInV1 calldata lockOrBurnIn)
        external
        virtual
        override
        returns (Pool.LockOrBurnOutV1 memory)
    {
        _validateLockOrBurn(lockOrBurnIn);

        _burn(lockOrBurnIn.amount);

        emit Burned(msg.sender, lockOrBurnIn.amount);

        return Pool.LockOrBurnOutV1({
            destTokenAddress: getRemoteToken(lockOrBurnIn.remoteChainSelector),
            destPoolData: _encodeLocalDecimals()
        });
    }

    /// @notice Mint tokens from the pool to the recipient
    /// @dev The _validateReleaseOrMint check is an essential security check
    function releaseOrMint(Pool.ReleaseOrMintInV1 calldata releaseOrMintIn)
        external
        virtual
        override
        returns (Pool.ReleaseOrMintOutV1 memory)
    {
        _validateReleaseOrMint(releaseOrMintIn);

        // Calculate the local amount
        uint256 localAmount =
            _calculateLocalAmount(releaseOrMintIn.amount, _parseRemoteDecimals(releaseOrMintIn.sourcePoolData));

        // Mint to the receiver
        IChildToken(address(i_token)).deposit(releaseOrMintIn.receiver, abi.encode(localAmount));

        emit Minted(msg.sender, releaseOrMintIn.receiver, localAmount);

        return Pool.ReleaseOrMintOutV1({destinationAmount: localAmount});
    }
}
