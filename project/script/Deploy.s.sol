// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { stdJson } from "forge-std/StdJson.sol";

import { Core } from "../src/Core.sol";
import { AccountImpl } from "../src/AccountImpl.sol";
import { BridgeConnector } from "../src/connectors/BridgeConnector.sol";
import { DEXConnector } from "../src/connectors/DEXConnector.sol";

contract DeployScript is Script {
    using stdJson for string;

    function run() external {
        // ───── Load ENV ─────
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        address dex = vm.envAddress("DEX_ADDRESS");

        // ───── Detect chain ID and load bridge ─────
        uint256 chainId = block.chainid;
        address bridge;

        if (chainId == 11155111) {
            // Sepolia
            bridge = vm.envAddress("SEP_BRIDGE_ADDRESS");
            console.log("bridge", bridge);
        } else if (chainId == 133) {
            // HashKey Testnet
            bridge = vm.envAddress("HSK_BRIDGE_ADDRESS");
            console.log("bridge", bridge);
        } else {
            revert("Unsupported chain ID");
        }

        // ───── Start Broadcasting ─────
        vm.startBroadcast(deployerPrivateKey);

        AccountImpl accountImpl = new AccountImpl();
        Core core = new Core(address(accountImpl));
        BridgeConnector bridgeConnector = new BridgeConnector();
        DEXConnector dexConnector = new DEXConnector();

        core.setDEX(dex);
        core.setBridge(bridge);
        core.setBridgeConnector(address(bridgeConnector));
        core.setDexConnector(address(dexConnector));

        vm.stopBroadcast();

        // ───── Logging ─────
        console.log("Deployer:", deployer);
        console.log("AccountImpl:", address(accountImpl));
        console.log("Core:", address(core));
        console.log("BridgeConnector:", address(bridgeConnector));
        console.log("DEXConnector:", address(dexConnector));
    }
}
