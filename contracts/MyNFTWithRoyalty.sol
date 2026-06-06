// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/**
 * @title MyNFTWithRoyalty
 * @dev 支持 ERC2981 版税标准的 NFT 合约
 * @notice 继承 IERC2981 接口，实现版税功能
 */
contract MyNFTWithRoyalty is ERC721URIStorage, Ownable, IERC2981 {
    uint256 private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintPrice = 0.01 ether;

    address private _royaltyReceiver;
    uint96 private _royaltyBps;

    event NFTMinted(
        address indexed minter,
        uint256 indexed tokenId,
        string uri
    );

    /**
     * @dev 构造函数
     * @param royaltyReceiver_ 版税接收地址
     * @param royaltyBps_ 版税比例，基点单位，10000 = 100%
     */
    constructor(
        address royaltyReceiver_,
        uint96 royaltyBps_
    )
        ERC721("MyNFTWithRoyalty", "MNFR")
        Ownable(msg.sender)
    {
        require(royaltyReceiver_ != address(0), "Invalid royalty receiver");
        require(royaltyBps_ <= 1000, "Royalty too high");

        _royaltyReceiver = royaltyReceiver_;
        _royaltyBps = royaltyBps_;
    }

    /**
     * @dev 铸造 NFT
     * @param uri NFT 元数据 URI
     */
    function mint(string memory uri) public payable returns (uint256) {
        require(_tokenIdCounter < MAX_SUPPLY, "Max supply reached");
        require(msg.value >= mintPrice, "Insufficient payment");

        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, uri);

        emit NFTMinted(msg.sender, newTokenId, uri);

        return newTokenId;
    }

    /**
     * @dev 获取 ERC2981 版税信息
     * @param tokenId Token ID
     * @param salePrice 售价
     * @return receiver 版税接收地址
     * @return royaltyAmount 版税金额
     */
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view override returns (address receiver, uint256 royaltyAmount) {
        tokenId;
        receiver = _royaltyReceiver;
        royaltyAmount = (salePrice * _royaltyBps) / 10000;
    }

    /**
     * @dev 设置版税信息
     * @param receiver 新的版税接收地址
     * @param bps 新的版税比例，基点单位，10000 = 100%
     */
    function setRoyaltyInfo(address receiver, uint96 bps) external onlyOwner {
        require(receiver != address(0), "Invalid receiver");
        require(bps <= 1000, "Royalty too high");

        _royaltyReceiver = receiver;
        _royaltyBps = bps;
    }

    function royaltyReceiver() external view returns (address) {
        return _royaltyReceiver;
    }

    function royaltyBps() external view returns (uint96) {
        return _royaltyBps;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage, IERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Withdraw failed");
    }
}