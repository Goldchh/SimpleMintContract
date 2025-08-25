// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";  
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
    * @title SimpleMint
    * @dev 一个简单的、允许用户支付固定费用铸造NFT的合约
    * 继承自 ERC721（NFT标准）、Ownable（权限控制）和 ReentrancyGuard（重入保护）
 */
contract SimpleMint is ERC721,Ownable ,ReentrancyGuard {
    uint256 private _tokenIdCounter; // 代币ID计数器
    uint256 public immutable MAX_SUPPLY; // 最大供应量  
    uint256 public immutable MINT_PRICE; // 铸造价格


    
    //@dev 当一个新的NFT被铸造时触发
    event Minted(address indexed to, uint256 tokenId); // 铸造事件

    constructor(string memory name, string memory symbol,
     uint256 maxSupply, uint256 mintPrice, address initialOwner) 
        ERC721(name, symbol) Ownable(initialOwner){
            _tokenIdCounter = 0; // 初始化代币ID计数器，从0开始
            MAX_SUPPLY = maxSupply; // 设置最大供应量
            MINT_PRICE = mintPrice; // 设置铸造价格
    }


    /**
    * @dev 允许用户支付固定费用铸造NFT
    * 通过 nonReentrant 修饰器防止重入攻击
    * 使用 payable 关键字允许合约接收ETH
     */
    function mint() external payable nonReentrant {
       
    }


    /**
    * @dev 允许合约所有者提取合约中积累的以太币
    * 通过 onlyOwner 修饰器限制只有合约所有者可以调用
    * 通过 nonReentrant 提供额外的安全层
    */
    function withdraw() external onlyOwner nonReentrant{
        
    }


    /**
    * @dev 返回当前已铸造的NFT总数
    * @return 当前tokenId计数器的值，即总供应量
     */
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }

/**
     * @dev 重写ERC721的 tokenURI 函数，返回某个Token ID对应的元数据URL
     * @param tokenId 要查询的NFT的ID
     * @return 该NFT的元数据URL（你可以先返回一个固定的测试URL）
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId < _tokenIdCounter && tokenId >= 0, "ERC721Metadata: URI query for nonexistent token");
        
        // 目前先返回一个固定值用于测试
        return string(abi.encodePacked("https://example.com/metadata/", Strings.toString(tokenId), ".json"));
    }


   
}