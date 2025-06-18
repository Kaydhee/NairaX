// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {NairaX} from "./NairaX.sol";

/**
 * @title SwapNaira - ETH/Token to NairaX Exchange
 * @notice Facilitates conversions between ETH/ERC20s and NairaX
 * @dev Implements reentrancy protection and proper access control
 * @author KAYDHEE
 */

contract SwapNaira is Ownable, ReentrancyGuard {
    // Using custom errors to reduce gas costs
    // ERRORS
    error SwapNaira__InvalidRate();
    error SwapNaira__UnsupportedToken();
    error SwapNaira__RateNotSet();
    error SwapNaira__TransferFailed();
    error SwapNaira__ZeroAmountProhibited();
    error SwapNaira__ContractNotInitialized();

    NairaX public immutable i_nairaToken;
    bool public initialized;

    // Token address to rate (e.g 1 ETH = 1,000,000 NGN = 1,000,000e18)
    mapping(address => uint256) public rates;
    mapping(address => bool) public supportedTokens;

    // EVENTS
    event RateUpdated(address indexed token, uint256 newRate);
    event TokenSupportedToggled(address indexed token, bool supported);
    event EthSwapped(address indexed user, uint256 ethIn, uint256 nairaOut);
    event TokenSwapped(address indexed user, address token, uint256 tokenIn, uint256 nairaOut);
    
    constructor(address _nairaToken) Ownable(msg.sender) {
        if(_nairaToken == address(0)) revert SwapNaira__ZeroAmountProhibited();
        i_nairaToken = NairaX(_nairaToken);
    }

    /**
     * @notice Initializes swap contract permissions
     */
    function initialize() external onlyOwner {
        i_nairaToken.setMinter(address(this));
        initialized = true;
    }

     // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // ADMIN FUNCTIONS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    function setRate(address token, uint256 rate) external onlyOwner {
        if(rate == 0) revert SwapNaira__InvalidRate();
        rates[token] = rate;
        emit RateUpdated(token, rate);
    }

    function setTokenSupport(address token, bool supported) external onlyOwner {
        if (token == address(0)) revert SwapNaira__ZeroAmountProhibited();
        supportedTokens[token] = supported;
        emit TokenSupportedToggled(token, supported);
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // USER FUNCTIONS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  

    function swapETHToNaira() external payable nonReentrant {
       if (!initialized) revert SwapNaira__ContractNotInitialized();
       if (msg.value == 0) revert SwapNaira__ZeroAmountProhibited();

       uint256 rate = rates[address(0)];
       if (rate == 0) revert SwapNaira__RateNotSet();

       uint nairaAmount = (msg.value * rate) / 1 ether;
       emit EthSwapped(msg.sender, msg.value, nairaAmount);
       i_nairaToken.mint(msg.sender, nairaAmount);
    }

    function swapTokenToNaira(address token, uint256 amount) external nonReentrant {
       if (!initialized) revert SwapNaira__ContractNotInitialized();
       if (!supportedTokens[token]) revert SwapNaira__UnsupportedToken();
       if (amount == 0) revert SwapNaira__ZeroAmountProhibited();

       uint256 rate = rates[token];
       if (rate == 0) revert SwapNaira__RateNotSet();

       bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
       if (!success) revert SwapNaira__TransferFailed();

       uint256 nairaAmount = (amount * rate) / 1 ether;
       emit TokenSwapped(msg.sender, token, amount, nairaAmount);
       i_nairaToken.mint(msg.sender, nairaAmount);
    }

    /**
     * @notice Emergency token recovery
     */

    function recoverERC20(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner(), amount);
    }
}