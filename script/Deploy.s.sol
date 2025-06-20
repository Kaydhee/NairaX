// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {NairaX} from "../src/NairaX.sol";
import {SwapNaira} from "../src/SwapNaira.sol";
import {TestToken} from "../src/TestToken.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
        address deployer = vm.addr(deployerPrivateKey); // ✅ Get deployer address
    
        vm.startBroadcast(deployerPrivateKey);

        // Deploy NairaX
        NairaX nairaToken = new NairaX(deployer);
        console.log("NairaX deployed to:", address(nairaToken));

        // Deploying SwapNaira
        SwapNaira swap = new SwapNaira(address(nairaToken));
        console.log("SwapNaira deployed to:", address(swap));

        // Transfering the ownership of NairaX to swapp contract
        nairaToken.transferOwnership(address(swap));

        // Deploy dummy TestBTC
        TestToken tBTC = new TestToken("Test Bitcoin", "tBTC", 1_000_000e18);
        console.log("TestBTC deployed to:", address(tBTC));

        // Setting Exchange rates
        // ETH
        swap.setRate(address(0), 1_000_000e18);
        swap.setRate(address(tBTC), 92_000_000e18);

        // Register tBTC as Supported Token
        swap.setTokenSupport(address(tBTC), true);

        vm.stopBroadcast();
    }
}