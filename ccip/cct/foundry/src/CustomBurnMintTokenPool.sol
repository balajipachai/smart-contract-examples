// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {CustomBurnMintTokenPoolAbstract} from "./CustomBurnMintTokenPoolAbstract.sol";
import {ITypeAndVersion} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/ITypeAndVersion.sol";
import {IBurnMintERC20} from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC20/IBurnMintERC20.sol";
import {TokenPool} from "@chainlink/contracts-ccip/src/v0.8/ccip/pools/TokenPool.sol";
import {IChildToken} from "./IChildToken.sol";

contract CustomBurnMintTokenPool is CustomBurnMintTokenPoolAbstract, ITypeAndVersion {
    string public constant override typeAndVersion = "CustomBurnMintTokenPool 1.0.0";

    constructor(
        IBurnMintERC20 token,
        uint8 localTokenDecimals,
        address[] memory allowlist,
        address rmnProxy,
        address router
    ) TokenPool(token, localTokenDecimals, allowlist, rmnProxy, router) {}

    function _burn(uint256 amount) internal virtual override {
        // Since, i_token is a ChildERC20, the withdraw function is called to burn the tokens
        IChildToken(address(i_token)).withdraw(amount);
    }
}
