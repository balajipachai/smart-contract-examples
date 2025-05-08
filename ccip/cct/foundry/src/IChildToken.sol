pragma solidity 0.8.24;

interface IChildToken {
    function grantRole(bytes32 role, address account) external;
    function deposit(address user, bytes calldata depositData) external;
    function withdraw(uint256 amount) external;
}
