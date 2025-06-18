// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/**
 * @title TestToken - ERC20 Token for Testing Purposes
 * @notice A simple mintable ERC20 token for testing environments
 * @dev Inherits from OpenZeppelin's ERC20 implementation
 * @author KAYDHEE
 */

contract TestToken is ERC20 {
    // ERRORS
    error TestToken__ZeroAddressProhibited();
    error TestToken__InvalidSupplyAmount();

     /**
     * @dev Initializes the token with name, symbol and initial supply
     * @param name The name of the token (e.g., "TestToken")
     * @param symbol The symbol of the token (e.g., "TEST")
     * @param initialSupply Initial token supply (in wei units)
     */

        constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        if (initialSupply == 0) revert TestToken__InvalidSupplyAmount();
        if (msg.sender == address(0)) revert TestToken__ZeroAddressProhibited();

        _mint(msg.sender, initialSupply);
    }

     /**
     * @notice Mints additional tokens (for testing purposes)
     * @dev No access control - for testing only!
     * @param to Recipient address
     * @param amount Amount to mint (in wei units)
     */
    function mint(address to, uint256 amount) external {
        if (to == address(0)) revert TestToken__ZeroAddressProhibited();
        if (amount == 0) revert TestToken__InvalidSupplyAmount();

        _mint(to, amount);
    }
}

