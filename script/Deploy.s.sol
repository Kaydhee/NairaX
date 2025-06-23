// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {NairaX} from "../src/NairaX.sol";
import {SwapNaira} from "../src/SwapNaira.sol";
import {TestToken} from "../src/TestToken.sol";

contract DeployScript is Script {
    error NairaX__InvalidDeployer(address deployer, uint256 balance);
    error NairaX__OwnershipMismatch(address expected, address actual);
    error NairaX__UninitializedContract();
    error NairaX__ConfigurationFailed(string setting);
    
    uint256 public constant INITIAL_TBTC_SUPPLY = 1_000_000e18;
    uint256 public constant ETH_TO_NGN_RATE = 1_000_000e18;
    uint256 public constant BTC_TO_NGN_RATE = 92_000_000e18;

    function run() external {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
        address deployer = vm.addr(deployerPrivateKey);

        if (deployer.balance == 0) {
            revert NairaX__InvalidDeployer(deployer, 0);
        }

        console.log("\n=== Deployment Started ===");
        console.log("Deployer Address:", deployer);
        console.log("Deployer Balance:", deployer.balance / 1e18, "ETH");
    
        vm.startBroadcast(deployerPrivateKey);

        // Deploy NairaX
        NairaX nairaToken = new NairaX(deployer);
        if (nairaToken.owner() != deployer) {
            revert NairaX__OwnershipMismatch(deployer, nairaToken.owner());
        }
        console.log("NairaX deployed to:", address(nairaToken));

        // Deploying SwapNaira
        SwapNaira swap = new SwapNaira(address(nairaToken));
        console.log("SwapNaira deployed to:", address(swap));

        // Transfering the ownership of NairaX to swapp contract
        nairaToken.transferOwnership(address(swap));
        if (nairaToken.owner() != address(swap)) {
            revert NairaX__OwnershipMismatch(address(swap), nairaToken.owner());
        }

        swap.initialize();
        if (!swap.initialized()) {
            revert NairaX__UninitializedContract();
        }

        // Deploy dummy TestBTC
        TestToken tBTC = new TestToken("Test Bitcoin", "tBTC", INITIAL_TBTC_SUPPLY);
        console.log("TestBTC deployed to:", address(tBTC));

        try swap.setRate(address(0), ETH_TO_NGN_RATE) {
        } catch  {
            revert NairaX__ConfigurationFailed("Eth rate");
        }

        try swap.setRate(address(tBTC), BTC_TO_NGN_RATE) {

        } catch {
            revert NairaX__ConfigurationFailed("BTC rate");
        }

        try swap.setTokenSupport(address(tBTC), true) {

        } catch {
            revert NairaX__ConfigurationFailed("Token support");
        }

        vm.stopBroadcast(); 

        console.log("\n=== Deployment Successful ===");
        console.log("NairaX:", address(nairaToken));
        console.log("SwapNaira:", address(swap));
        console.log("TestBTC:", address(tBTC));
        console.log("\nNext Steps:");
        console.log("1. Verify contracts (if on live network)");
        console.log("2. Run tests: forge test");
    }
}