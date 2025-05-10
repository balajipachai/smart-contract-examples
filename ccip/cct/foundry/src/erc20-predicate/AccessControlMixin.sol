// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {AccessControl} from
    "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/access/AccessControl.sol";

contract AccessControlMixin is AccessControl {
    string private _revertMsg;

    function _setupContractId(string memory contractId) internal {
        _revertMsg = string(abi.encodePacked(contractId, ": INSUFFICIENT_PERMISSIONS"));
    }

    modifier only(bytes32 role) {
        require(hasRole(role, _msgSender()), _revertMsg);
        _;
    }
}
