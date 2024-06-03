// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataMarketplace {
    struct Data {
        address seller;
        string description;
        string ipfsHash;
        uint256 price;
        bool purchased;
    }

    uint256 public dataCount;
    mapping(uint256 => Data) public dataItems;

    event DataListed(uint256 dataId, address seller, string description, uint256 price);
    event DataPurchased(uint256 dataId, address buyer);

    function listData(string memory description, string memory ipfsHash, uint256 price) external {
        dataCount++;
        dataItems[dataCount] = Data(msg.sender, description, ipfsHash, price, false);
        emit DataListed(dataCount, msg.sender, description, price);
    }

    function purchaseData(uint256 dataId) external payable {
        Data storage data = dataItems[dataId];
        require(!data.purchased, "Data already purchased");
        require(msg.value == data.price, "Incorrect price");

        data.purchased = true;
        payable(data.seller).transfer(msg.value);
        emit DataPurchased(dataId, msg.sender);
    }

    function getData(uint256 dataId) external view returns (address seller, string memory description, string memory ipfsHash, uint256 price, bool purchased) {
        Data storage data = dataItems[dataId];
        return (data.seller, data.description, data.ipfsHash, data.price, data.purchased);
    }
}
