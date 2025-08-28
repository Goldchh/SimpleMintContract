// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";  
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
    * @title SimpleMint
    * @dev g
    * 继承自 ERC721（NFT标准）、Ownable（权限控制）和 ReentrancyGuard（重入保护）
 */
contract SimpleMint is ERC721,Ownable ,ReentrancyGuard {
    uint256 private _tokenIdCounter; // 代币ID计数器
    string  private _baseTokenURI;
    uint256 public immutable MAX_SUPPLY; // 最大供应量  
    uint256 public immutable MINT_PRICE; // 铸造价格
    
    //@dev 当一个新的NFT被铸造时触发
    event Minted(address indexed to, uint256 tokenId); // 铸造事件

    constructor(string memory name, string memory symbol,
     uint256 maxSupply, uint256 mintPrice) // 新增：基础URI参数
        ERC721(name, symbol)  Ownable() {
            _tokenIdCounter = 0; // 初始化代币ID计数器，从0开始
            MAX_SUPPLY = maxSupply; // 设置最大供应量
            MINT_PRICE = mintPrice; // 设置铸造价格
             //_baseTokenURI = baseURI_; // 设置基础URI
    }


    /**
    * @dev 允许用户支付固定费用铸造NFT
    * 通过 nonReentrant 修饰器防止重入攻击
    * 使用 payable 关键字允许合约接收ETH
     */
    function mint() external payable nonReentrant {
        require(msg.value >= MINT_PRICE,"Insufficient funds"); //  检查支付金额是否足够 
        require(_tokenIdCounter < MAX_SUPPLY,"Max supply reached");//检查是否超过最大供应量
        uint256 tokenId = _tokenIdCounter;//获取当前tokenId，然后递增计数器
        _tokenIdCounter++;
        _safeMint(msg.sender,tokenId);//使用 _safeMint 安全地铸造NFT给 msg.sender
        emit Minted(msg.sender,tokenId);//触发 Minted 事件

    }


    /**
    * @dev 允许合约所有者提取合约中积累的以太币
    * 通过 onlyOwner 修饰器限制只有合约所有者可以调用
    * 通过 nonReentrant 提供额外的安全层
    * 使用 `call` 而不是 `transfer` 进行资金转移，避免Gas限制问题
    */
    function withdraw() external onlyOwner nonReentrant{
         // TODO: 在这里实现提款逻辑：
        uint256 balance = address(this).balance;//获取合约当前的余额
        require(balance > 0,"SimpleMint: No funds to withdraw");// 2. 使用 call 函数将余额发送给所有者
        // 3. 检查 call 是否成功 (require(success, "Withdrawal failed"))
        (bool success,  /* data */) = owner().call{value: balance}("");

        require(success, "Withdrawal failed");  

        // 触发一个事件来记录提款操作（增强可追溯性）
        
        // emit  Withdrawn(owner(), balance);
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
        //return string(abi.encodePacked("https://example.com/metadata/", Strings.toString(tokenId), ".json"));
        // 拼接基础URI和tokenId
        return string(
            abi.encodePacked(
                _baseTokenURI,
                Strings.toString(tokenId),
                ".json"
            )
        );
    }

    // 可选：允许所有者后期更新基础URI
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }


   
}