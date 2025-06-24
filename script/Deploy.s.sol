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

    NairaX private _nairaToken;
    SwapNaira private _swap;
    TestToken private _tBTC;

    function nairaToken() public view returns (NairaX) {
        return _nairaToken;
    }

    function swap() public view returns (SwapNaira) {
        return _swap;
    }

    function tBTC() public view returns (TestToken) {
        return _tBTC;
    }

    function run() external {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
        address deployer = vm.addr(deployerPrivateKey);

    if (block.chainid != 31337 && deployer.balance == 0) { 
        revert NairaX__InvalidDeployer(deployer, 0);
    }

        console.log("\n=== Deployment Started ===");
        console.log("Deployer Address:", deployer);
        console.log("Deployer Balance:", deployer.balance / 1e18, "ETH");
    
        vm.startBroadcast(deployerPrivateKey);

        
        // NairaX nairaToken = new NairaX(deployer);
        _nairaToken = new NairaX(deployer);
        if (_nairaToken.owner() != deployer) {
            revert NairaX__OwnershipMismatch(deployer, _nairaToken.owner());
        }
        console.log("NairaX deployed to:", address(_nairaToken));

        
        // SwapNaira swap = new SwapNaira(address(nairaToken));
        _swap = new SwapNaira(address(_nairaToken));
        console.log("SwapNaira deployed to:", address(_swap));

        _nairaToken.transferOwnership(address(_swap));
        if (_nairaToken.owner() != address(_swap)) {
            revert NairaX__OwnershipMismatch(address(_swap), _nairaToken.owner());
        }

        _swap.initialize();
        if (!_swap.initialized()) {
            revert NairaX__UninitializedContract();
        }

        // TestToken tBTC = new TestToken("Test Bitcoin", "tBTC", INITIAL_TBTC_SUPPLY);
        _tBTC = new TestToken("Test Bitcoin", "tBTC", INITIAL_TBTC_SUPPLY);
        console.log("TestBTC deployed to:", address(_tBTC));

        try _swap.setRate(address(0), ETH_TO_NGN_RATE) {
        } catch  {
            revert NairaX__ConfigurationFailed("Eth rate");
        }

        try _swap.setRate(address(_tBTC), BTC_TO_NGN_RATE) {

        } catch {
            revert NairaX__ConfigurationFailed("BTC rate");
        }

        try _swap.setTokenSupport(address(_tBTC), true) {

        } catch {
            revert NairaX__ConfigurationFailed("Token support");
        }

        vm.stopBroadcast(); 

        console.log("\n=== Deployment Successful ===");
        console.log("NairaX:", address(_nairaToken));
        console.log("SwapNaira:", address(_swap));
        console.log("TestBTC:", address(_tBTC));
        console.log("\nNext Steps:");
        console.log("1. Verify contracts (if on live network)");
        console.log("2. Run tests: forge test");
    }
}