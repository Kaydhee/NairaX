// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title NairaX - Nigerian Naira Stablecoin
 * @notice ERC20 token with controlled minting capability
 * @dev Inherits from OpenZeppelin's ERC20 and Ownable
 * @author KAYDHEE
 */

contract NairaX is ERC20, Ownable {
    // ERRORS
    error NairaX__ZeroAddressProhibited();
    error NairaX__InvalidMintAmount();
    error NairaX__UnauthorizedMinter();

    address public minter;

    constructor(address initialOwner) ERC20("NairaX", "NRX") Ownable(initialOwner) {
        if (initialOwner == address(0)) revert NairaX__ZeroAddressProhibited();
    }

    /**
     * @notice Designates a minter address
     * @param _minter Address allowed to mint tokens
     */
    function setMinter(address _minter) external onlyOwner {
        if (_minter == address(0)) revert NairaX__ZeroAddressProhibited();
        minter = _minter;
    }

     /**
     * @notice Mints new tokens - must be minter
     * @dev Changed to public visibility to be callable by SwapNaira
     */
    function mint(address to, uint256 amount) public {
        if (msg.sender != minter) revert NairaX__UnauthorizedMinter();
        if (to == address(0)) revert NairaX__ZeroAddressProhibited();
        if (amount == 0) revert NairaX__InvalidMintAmount();
        _mint(to, amount);
    }
}


