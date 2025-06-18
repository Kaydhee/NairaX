// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract NairaX is ERC20, Ownable {
    constructor(address _initialOwner) ERC20("NairaX", "NRX") Ownable(_initialOwner) {
    }

    ///@notice Mint new tokens (only owner, to be used by swap contract)
    function mint(address to, uint amount) external onlyOwner {
        _mint(to, amount);
    }
}


