// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract SocietiezAccessControlUpgradeable is Initializable{
    address public ceoAddress;
    address payable public cfoAddress;
    address public cooAddress;
    bool public isSale;

    function __SocietiezAccessControl_init() internal onlyInitializing {
        ceoAddress = msg.sender;
        isSale = false;
    }

    modifier onlyCEO() {
        require(
            msg.sender == ceoAddress,
            "operation can only be executed by CEO"
        );
        _;
    }

    modifier onlyCFO() {
        require(
            msg.sender == cfoAddress,
            "operation can only be executed by CFO"
        );
        _;
    }

    modifier onlyCOO() {
        require(
            msg.sender == cooAddress,
            "operation can only be executed by COO"
        );
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == ceoAddress ||
                msg.sender == cfoAddress ||
                msg.sender == cooAddress,
            "operation can only be executed by chiefs"
        );
        _;
    }

    modifier forSale() {
        require(isSale, "not for sale right now");
        _;
    }

    function _setCEO(address _newCEO) internal  onlyCEO {
        require(_newCEO != address(0));
        ceoAddress = _newCEO;
    }

    function _setCFO(address payable _newCFO) internal  onlyCEO {
        cfoAddress = _newCFO;
    }

    function _setCOO(address _newCOO) internal  onlyCEO {
        cooAddress = _newCOO;
    }

    function _setIsSale(bool _status) internal  onlyCFO {
        isSale = _status;
    }
}

contract societiez_joining_token is
    ERC1155Upgradeable,
    OwnableUpgradeable,
    ERC1155SupplyUpgradeable,
    SocietiezAccessControlUpgradeable
{
    uint256 public PLATINIUM_qty;
    uint256 public GOLD_qty;
    uint256 public SILVER_qty;
    uint256[] public price;

    function initialize() initializer public  {
        __ERC1155_init(
            "https://malay44.github.io/erc1155_token/tokens_metadata/{id}.json"
        );
        __Ownable_init();
        __ERC1155Supply_init();
        __SocietiezAccessControl_init();
        PLATINIUM_qty = 100;
        GOLD_qty = 900;
        SILVER_qty = 1000;
        price = [60000000000000, 30000000000000, 10000000000000];
    }


    function setPLATINIUM_qty(uint256 quantity) external {
        PLATINIUM_qty = quantity;
    }

    function setGOLD_qty(uint256 quantity) external {
        GOLD_qty = quantity;
    }

    function setSILVER_qty(uint256 quantity) external {
        SILVER_qty = quantity;
    }

    function setURI(string memory newuri) public onlyCLevel {
        _setURI(newuri);
    }

    function setPrice(uint256[] memory _newPrices) public onlyCLevel {
        price = _newPrices;
    }

    function setCEO(address _newCEO) external onlyCEO {
        _setCEO(_newCEO);
    }

    function setCFO(address payable _newCFO) external onlyCEO {
        _setCFO(_newCFO);
    }

    function setCOO(address _newCOO) external onlyCEO {
        _setCOO(_newCOO);
    }

    function setIsSale(bool _status) external onlyCFO {
        _setIsSale(_status); 
    }

    function mint() public virtual {
        require(
            balanceOf(msg.sender, 0) == 0 &&
                balanceOf(msg.sender, 1) == 0 &&
                balanceOf(msg.sender, 2) == 0,
            "you have already joined the waitlist"
        );
        if (totalSupply(0) < PLATINIUM_qty) {
            _mint(msg.sender, 0, 1, "");
        } else if (totalSupply(1) < GOLD_qty) {
            _mint(msg.sender, 1, 1, "");
        } else if (totalSupply(2) < SILVER_qty) {
            _mint(msg.sender, 2, 1, "");
        } else {
            require(false, "Waitlist tokens minted out");
        }
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyCLevel {
        _mintBatch(to, ids, amounts, data);
    }

    function reserveTokens() public onlyCLevel virtual {
        uint256[] memory ids;
        ids[0] = 0;
        ids[1] = 1;
        ids[2] = 2;

        uint256[] memory amounts;
        amounts[0] = 20;
        amounts[1] = 10;
        amounts[2] = 5;

        _mintBatch(ceoAddress, ids, amounts, "");
    }

    function buyToken(uint256 id, uint256 amount) public payable forSale virtual {
        require(id <= price.length, "no such token exists");
        require(
            msg.value == price[id],
            "please make sure that you send appropriate amount of ethers"
        );
        _mint(msg.sender, id, amount, "");
    }

    function withdrawBalance(uint256 amount) external payable onlyCFO virtual {
        cfoAddress.transfer(amount);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155Upgradeable, ERC1155SupplyUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
