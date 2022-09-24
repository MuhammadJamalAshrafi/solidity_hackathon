// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TrackbackFood{

     address immutable owner;
     address importer = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
     address farmers = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

    uint productsCount = 0;

    struct productStruct{
        string name;
        string prouce_type;
        string landLocation;
        uint256 quantity;
        uint256 expectedPrice;
        string expDate;
    }

    event logActivity(string message, address);
     mapping (address => productStruct) productInfo;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender == owner)
        _;
    }

    function productAdd(
        address _productID,
        string memory _name,
        string memory _prouce_type,
        string memory _landLocation,
        uint256 _quantity,
        string memory _expDate,
        uint256 _expectedPrice
    ) onlyOwner public {
        productInfo[_productID].name = _name;
        productInfo[_productID].prouce_type = _prouce_type;
        productInfo[_productID].landLocation = _landLocation;
        productInfo[_productID].quantity = _quantity;
        productInfo[_productID].expDate = _expDate;
        productInfo[_productID].expectedPrice = _expectedPrice;

       productsCount++;
        emit logActivity ("New Product, product ID:", _productID);        
    }

    function totalProducts() public view onlyOwner returns (uint){
        return productsCount;
    }

         function getProductDetails(address _productID) public view onlyOwner returns(
          productStruct memory
          ){return productInfo[_productID];}
    }
