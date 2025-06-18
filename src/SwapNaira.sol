// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {NairaX} from "./NairaX.sol";

contract SwapNaira is Ownable {
    /// @notice The NGN stable token (mintable)    
    NairaX public NairaToken;

    /// @notice Token address to rate (e.g 1 ETH = 1,000,000 NGN = 1,000,000e18)
    mapping(address => uint256) public rates;

    /// @notice List of supported tokens
    mapping(address => bool) public isTokenSupported;

    // EVENTS
    event SwapETH(address indexed user, uint256 ethAmount, uint256 ngnMinted);
    event SwapToken(address indexed user, address token, uint256 tokenAmount, uint256 ngnMinted);
    event RateUpdated(address indexed token, uint256 newRate);
    event TokenSupported(address indexed token, bool supported);

    constructor(address _nairaToken) {
        nairaToken = NairaX(_nairaToken);
    }

     // --------------------------------------------
    // 🔐 Admin Functions
    // --------------------------------------------

    function setRate(address token, uint256 rateInNGN) external onlyOwner {
        require(rateInNGN > 0, "Rate must be greater than 0");
        rates[token] = rateInNGN;
        emit RateUpdated(token, rateInNGN);
    }

    function addSupportedToken(address token) external onlyOwner {
        isTokenSupported[token] = true;
        emit TokenSupported(token, true);
    }

    function removeSupportedToken(address token) external onlyOwner {
        isTokenSupported[token] = false;
        emit TokenSupported(token, false);
    }
}