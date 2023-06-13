// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/metatx/ERC2771ContextUpgradeable.sol";

contract societiez_joining_token is
    ERC1155Upgradeable,
    OwnableUpgradeable,
    ERC1155SupplyUpgradeable,
    ERC2771ContextUpgradeable
{
    address public ceoAddress;
    address payable public cfoAddress;
    address public cooAddress;
    bool public isSale;
    uint256 public Elite_qty;
    uint256 public Prime_qty;
    uint256 public Noble_qty;
    uint256[] public price;
    address public trustedForwarder;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address forwarder)
        ERC2771ContextUpgradeable(forwarder)
    {
        trustedForwarder = forwarder;
    }

    function initialize() initializer public  {
        __ERC1155_init(
            "https://societiez.github.io/erc1155_token/tokens_metadata/{id}.json"
        );
        __Ownable_init();
        __ERC1155Supply_init();
        __Context_init();
        ceoAddress = msg.sender;
        isSale = false;
        Elite_qty = 500;
        Prime_qty = 4500;
        Noble_qty = 95000;
        price = [60000000000000, 30000000000000, 10000000000000];
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

    function _msgSender() internal view override(ContextUpgradeable, ERC2771ContextUpgradeable) returns(address sender) {
        return ERC2771ContextUpgradeable._msgSender();
    } 

    function _msgData() internal view override(ContextUpgradeable, ERC2771ContextUpgradeable) returns(bytes calldata){
        return ERC2771ContextUpgradeable._msgData();
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

    function setElite_qty(uint256 quantity) external onlyCLevel {
        Elite_qty = quantity;
    }

    function setPrime_qty(uint256 quantity) external onlyCLevel {
        Prime_qty = quantity;
    }

    function setNoble_qty(uint256 quantity) external onlyCLevel {
        Noble_qty = quantity;
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

    function mintNFT(address user) public virtual {
        require(
            balanceOf(user, 0) == 0 &&
                balanceOf(user, 1) == 0 &&
                balanceOf(user, 2) == 0,
            "you have already joined the waitlist"
        );
        if (totalSupply(0) < Elite_qty) {
            _mint(user, 0, 1, "");
        } else if (totalSupply(1) < Prime_qty) {
            _mint(user, 1, 1, "");
        } else if (totalSupply(2) < Noble_qty) {
            _mint(user, 2, 1, "");
        } else {
            require(false, "Waitlist tokens minted out");
        }
    }

    function buyNFT(uint256 id, uint256 qty, bytes memory data) public payable forSale {
        require(qty == 1, "you can only buy one token at a time");
        require(id == 0 || id == 1 || id == 2, "invalid token id");
        require(msg.value == price[id], "invalid price");
        _mint(msg.sender, id, qty, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyCLevel {
        _mintBatch(to, ids, amounts, data);
    }

    function withdrawBalance(uint256 amount) external payable onlyCFO virtual {
        cfoAddress.transfer(amount);
    }

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
