// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.17;

// import "@layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "./AAWalletFactory.sol";

// contract Bridge is NonblockingLzApp {
//     using SafeERC20 for IERC20;
    
//     AAWalletFactory public immutable walletFactory;
    
//     struct BridgeRequest {
//         uint256 telegramId;
//         uint256 amount;
//         address token;
//         uint16 targetChain;
//     }
    
//     mapping(bytes32 => BridgeRequest) public requests;

//     constructor(
//         address _lzEndpoint,
//         address _walletFactory
//     ) NonblockingLzApp(_lzEndpoint) {
//         walletFactory = AAWalletFactory(_walletFactory);
//     }

//     function bridgeTokens(
//         uint256 telegramId,
//         address token,
//         uint256 amount,
//         uint16 dstChainId
//     ) external payable {
//         // 사용자의 AA 월렛 확인
//         address userWallet = walletFactory.telegramToWallet(telegramId);
//         require(userWallet != address(0), "Wallet not found");
        
//         // 토큰 전송
//         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        
//         bytes32 requestId = keccak256(abi.encodePacked(
//             telegramId,
//             amount,
//             token,
//             block.timestamp
//         ));
        
//         requests[requestId] = BridgeRequest(
//             telegramId,
//             amount,
//             token,
//             dstChainId
//         );

//         // LayerZero 메시지 전송
//         bytes memory payload = abi.encode(requestId, telegramId, amount, token);
//         _lzSend(
//             dstChainId,
//             payload,
//             payable(msg.sender),
//             address(0x0),
//             bytes(""),
//             msg.value
//         );
//     }

//     function _nonblockingLzReceive(
//         uint16 srcChainId,
//         bytes memory srcAddress,
//         uint64 nonce,
//         bytes memory payload
//     ) internal override {
//         (bytes32 requestId, uint256 telegramId, uint256 amount, address srcToken) = 
//             abi.decode(payload, (bytes32, uint256, uint256, address));
            
//         address userWallet = walletFactory.telegramToWallet(telegramId);
//         require(userWallet != address(0), "Destination wallet not found");
        
//         // 대상 체인의 토큰 전송
//         address localToken = chainIdToTokenMapping[srcChainId][srcToken];
//         IERC20(localToken).safeTransfer(userWallet, amount);
//     }
// }