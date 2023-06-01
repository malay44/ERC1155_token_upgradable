// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./societiez_joining_token.sol";

contract societiez_joining_token_v2 is societiez_joining_token {
    uint256 public DIAMOND_qty;
    uint256 public EMERALD_qty;
    uint256[] public newPrice;

    function initializeV2() initializer public {
        DIAMOND_qty = 50;
        EMERALD_qty = 25;
        newPrice = [90000000000000, 80000000000000, 60000000000000, 30000000000000, 10000000000000];
    }

    function setDIAMOND_qty(uint256 quantity) external onlyCLevel {
        DIAMOND_qty = quantity;
    }

    function setEMERALD_qty(uint256 quantity) external onlyCLevel {
        EMERALD_qty = quantity;
    }

    function setNewPrice(uint256[] memory _newPrices) external onlyCLevel {
        newPrice = _newPrices;
    }

    function mint() public override virtual {
        require(
            balanceOf(msg.sender, 0) == 0 &&
                balanceOf(msg.sender, 1) == 0 &&
                balanceOf(msg.sender, 2) == 0 &&
                balanceOf(msg.sender, 3) == 0 &&
                balanceOf(msg.sender, 4) == 0,
            "you have already joined the waitlist"
        );
        if (totalSupply(0) < EMERALD_qty) {
            _mint(msg.sender, 0, 1, "");
        } else if (totalSupply(1) < DIAMOND_qty) {
            _mint(msg.sender, 1, 1, "");
        } else if (totalSupply(2) < PLATINIUM_qty) {
            _mint(msg.sender, 2, 1, "");
        } else if (totalSupply(3) < GOLD_qty) {
            _mint(msg.sender, 3, 1, "");
        } else if (totalSupply(4) < SILVER_qty) {
            _mint(msg.sender, 4, 1, "");
        } else {
            revert("Waitlist tokens minted out");
        }
    }

    function buyToken(uint256 id, uint256 amount) public payable forSale override virtual {
        require(id < newPrice.length, "no such token exists");
        require(
            msg.value == newPrice[id],
            "please make sure that you send the appropriate amount of ethers"
        );
        _mint(msg.sender, id, amount, "");
    }
}