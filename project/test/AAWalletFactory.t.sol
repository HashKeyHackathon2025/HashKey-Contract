// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/console.sol";

import "forge-std/Test.sol";
import "../src/AAWalletFactory.sol";
import "../src/Proxy.sol";
import "../src/Account.sol" as AccountContract;
import "../src/AddressesProvider.sol";

contract AAWalletFactoryTest is Test {
    AAWalletFactory public factory;
    AddressesProvider public provider;
    AccountContract.Account public implementation;
    
    address public owner = address(0x1);
    uint256 public telegramId = 123456789;
    
    function setUp() public {
        // 컨트랙트 배포
        provider = new AddressesProvider(owner);
        implementation = new AccountContract.Account(address(provider));
        
        // AddressesProvider 설정
        vm.prank(owner);  // owner로 전환
        provider.setAddress(bytes32("ACCOUNT"), address(implementation));
        
        // Factory 배포
        factory = new AAWalletFactory(address(provider));
        
        vm.label(owner, "Owner");
        vm.label(address(factory), "Factory");
        vm.label(address(provider), "Provider");
        vm.label(address(implementation), "Implementation");
    }
    
    function testCreateWallet() public {
        // 지갑 생성
        vm.prank(owner);
        address walletAddress = factory.createWallet(telegramId);
        
        // 검증
        console.log("Telegram Id", telegramId);
        console.log("Wallet Address", walletAddress);

        assertTrue(walletAddress != address(0), "Wallet should be created");
        assertEq(factory.walletByTelegramId(telegramId), walletAddress, "Wallet address should be mapped to telegramId");
        assertEq(factory.telegramIdByWallet(walletAddress), telegramId, "TelegramId should be mapped to wallet address");
    }
    
    function testCannotCreateDuplicateWallet() public {
        // 첫 번째 지갑 생성
        vm.prank(owner);
        factory.createWallet(telegramId);
        
        // 같은 텔레그램 ID로 두 번째 지갑 생성 시도
        vm.prank(owner);
        vm.expectRevert("Wallet already exists");
        factory.createWallet(telegramId);
    }
    
    function testWalletInitialization() public {
        // 지갑 생성
        vm.prank(owner);
        address walletAddress = factory.createWallet(telegramId);
        
        // 생성된 지갑이 올바르게 초기화되었는지 확인
        address walletOwner = AccountContract.Account(payable(walletAddress)).owner();
        assertEq(walletOwner, owner, "Wallet owner should be set correctly");
    }
    
    function testGetWalletAddress() public {
        // 지갑 생성
        vm.prank(owner);
        address expectedAddress = factory.createWallet(telegramId);
        
        // getWalletAddress 함수 테스트
        address retrievedAddress = factory.getWalletAddress(telegramId);
        assertEq(retrievedAddress, expectedAddress, "Retrieved address should match created wallet");
    }
    
    function testNonExistentWallet() public {
        // 존재하지 않는 텔레그램 ID로 지갑 조회
        address walletAddress = factory.getWalletAddress(999999);
        assertEq(walletAddress, address(0), "Non-existent wallet should return zero address");
    }
    
    // 가스 사용량 테스트
    function testGasUsage() public {
        vm.prank(owner);
        
        uint256 gasBefore = gasleft();
        factory.createWallet(telegramId);
        uint256 gasUsed = gasBefore - gasleft();
        
        emit log_named_uint("Gas Used for Wallet Creation", gasUsed);
        assertTrue(gasUsed < 500000, "Gas usage should be reasonable");
    }
}