// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import "./Tools.sol";

contract CrateContract {
    uint256 public crateCounter;

    event ViewCrate(
        uint256 id,
        string title,
        string category,
        string description,
        string imageUrl,
        bool premium,
        address owner,
        address creator,
        uint256 amount,
        bool isSalable,
        uint256 updateAt,
        uint256 createAt
    );

    struct Crate {
        uint256 id;
        string title;
        string category;
        string description;
        string imageUrl;
        bool premium;
        address owner;
        address creator;
        uint256 amount;
        bool isSalable;
        uint256 updateAt;
        uint256 createAt;
    }

    mapping(uint256 => Crate) public crates;

    constructor() {
        crates[crateCounter] = Crate(
            crateCounter,
            "Genesis",
            "Smart Contract",
            "The first crate",
            "https://github.com/metalpoch/crypto-crate",
            true,
            msg.sender,
            msg.sender,
            0,
            false,
            block.timestamp,
            block.timestamp
        );
        crateCounter++;
    }

    function createCrate(
        string memory _title,
        string memory _category,
        string memory _description,
        string memory _imageUrl,
        bool _premium,
        uint256 _amount,
        bool _isSalable
    ) public {
        crates[crateCounter] = Crate(
            crateCounter,
            _title,
            _category,
            _description,
            _imageUrl,
            _premium,
            msg.sender,
            msg.sender,
            _amount,
            _isSalable,
            block.timestamp,
            block.timestamp
        );
        crateCounter++;

        emit ViewCrate(
            crateCounter,
            _title,
            _category,
            _description,
            _imageUrl,
            _premium,
            msg.sender,
            msg.sender,
            _amount,
            _isSalable,
            block.timestamp,
            block.timestamp
        );
    }

    function updateCrate(
        uint256 _id,
        string memory _title,
        string memory _category,
        string memory _description,
        string memory _imageUrl,
        bool _premium,
        uint256 _amount,
        bool _isSalable
    ) public {
        require(
            msg.sender == crates[_id].owner,
            "You can only update your products"
        );

        crates[_id].title = _title;
        crates[_id].category = _category;

        crates[_id].description = _description;
        crates[_id].imageUrl = _imageUrl;
        crates[_id].premium = _premium;
        crates[_id].amount = _amount;
        crates[_id].isSalable = _isSalable;
        crates[_id].updateAt = block.timestamp;

        emit ViewCrate(
            crateCounter,
            _title,
            _category,
            _description,
            _imageUrl,
            _premium,
            msg.sender,
            msg.sender,
            _amount,
            _isSalable,
            block.timestamp,
            block.timestamp
        );
    }

    function buyCrate(address payable _recipient, uint256 _id) public payable {
        require(crates[_id].isSalable == true, "The crate is not for sale");
        require(msg.value == crates[_id].amount, "Insufficient amount");

        _recipient.transfer(crates[_id].amount);
        crates[_id].owner = msg.sender;
    }

    function getCratesByOwner(address _owner)
        public
        view
        returns (Crate[] memory)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < crateCounter; i++) {
            if (crates[i].owner == _owner) {
                count++;
            }
        }

        Crate[] memory result = new Crate[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < crateCounter; i++) {
            if (crates[i].owner == _owner) {
                result[index] = crates[i];
                index++;
            }
        }

        return result;
    }

    function getCratesByCategory(string memory _category)
        public
        view
        returns (Crate[] memory)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < crateCounter; i++) {
            if (Tools.stringComparator(crates[i].category, _category)) {
                count++;
            }
        }

        Crate[] memory result = new Crate[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < crateCounter; i++) {
            if (Tools.stringComparator(crates[i].category, _category)) {
                result[index] = crates[i];
                index++;
            }
        }

        return result;
    }
}

