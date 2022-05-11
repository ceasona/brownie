// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract Wufeng is ERC1155 {

    using SafeMath for uint;

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) public balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    string[] public collections;

    mapping(address => uint[]) ownerCollections;

    mapping(uint256 => uint256) public tokenSupply;

    string public name;
    // Contract symbol
    string public symbol;

    address owner;
    constructor() ERC1155("www.wufeng.com") {
        owner = msg.sender;
        name = "Wufeng Blockchain Art Exchange";
        symbol = "WB";
    }

    modifier onlyOwner(address _user_address) {
        require(msg.sender == _user_address, "ERC1155: only owner");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == owner, "ERC1155: permission denied");
        _;
    }


    function _exist(uint[] memory _tokenIdxs, uint idx) private pure returns (bool){
        for (uint i = 0; i < _tokenIdxs.length; i++) {
            if (idx == _tokenIdxs[i]) {
                return true;
            }
        }
        return false;
    }

    function getAdmin() public view onlyAdmin() returns (address){
        return owner;
    }

    function addCollection(string memory description, uint number) public onlyAdmin() {
        require(number > 0, "Cannot print 0 pieces!");
        collections.push(description);
        uint _id = collections.length.sub(1);
        balances[_id][owner] = number;
        ownerCollections[msg.sender].push(_id);
        tokenSupply[_id] = number;
        _mint(owner, _id, number, "");
    }

    function batchAddCollection(string[] memory descriptions, uint[] memory numbers) public onlyAdmin() {
        require(descriptions.length == numbers.length);
        for (uint i = 0; i < numbers.length; i++) {
            addCollection(descriptions[i], numbers[i]);
        }
    }

    function getAllCollections() public view onlyAdmin() returns (string[] memory){
        return collections;
    }

    function getOwnerAllCollectionsId(address userAddress) public view onlyAdmin() returns (uint[] memory){
        uint[] memory result = new uint[](ownerCollections[userAddress].length);
        uint counter = 0;
        for (uint i = 0; i < ownerCollections[userAddress].length; i++) {
            if (balances[ownerCollections[userAddress][i]][userAddress] > 0) {
                result[counter] = ownerCollections[userAddress][i];
                counter++;
            }
        }
        return result;
    }

    function getOwnerAllCollections(address userAddress) public view onlyAdmin() returns (string[] memory){
        string[] memory result = new string[](ownerCollections[userAddress].length);
        uint counter = 0;
        for (uint i = 0; i < ownerCollections[userAddress].length; i++) {
            if (balances[ownerCollections[userAddress][i]][userAddress] > 0) {
                result[counter] = collections[ownerCollections[userAddress][i]];
                counter++;
            }
        }
        return result;
    }

    function getOwnerAllCollectionsNumber(address userAddress) public view onlyAdmin() returns (string[] memory, uint[] memory){
        string[] memory k = new string[](ownerCollections[userAddress].length);
        uint[] memory v = new uint[](ownerCollections[userAddress].length);
        uint counter = 0;
        for (uint i = 0; i < ownerCollections[userAddress].length; i++) {
            if (balances[ownerCollections[userAddress][i]][userAddress] > 0) {
                k[counter] = collections[ownerCollections[userAddress][i]];
                v[counter] = balances[ownerCollections[userAddress][i]][userAddress];
                counter++;
            }
        }
        return (k, v);
    }

    function getOwnerCollectionNumber(address userAddress, uint id) public view onlyAdmin() returns (uint){
        return balances[id][userAddress];
    }

    function transferFrom(address from, address to, uint id, uint number) public {
        require(owner == msg.sender || _operatorApprovals[from][to]);
        require(balances[id][from] >= number);
        balances[id][from] = balances[id][from].sub(number);
        balances[id][to] = balances[id][to].add(number);
        if (!_exist(ownerCollections[to], id)) {
            ownerCollections[to].push(id);
        }
//        safeTransferFrom(from, to, id, number, "");
    }

    function batchTransferFrom(address from, address to, uint[] memory ids, uint[] memory numbers) public {
        require(owner == msg.sender || _operatorApprovals[from][to]);
        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 _id = ids[i];
            uint256 _number = numbers[i];
            uint256 fromBalance = balances[_id][from];
            require(fromBalance >= _number, "ERC1155: insufficient balance for transfer");
            unchecked {
                balances[_id][from] = fromBalance - _number;
            }
            balances[_id][to] += _number;
            if (!_exist(ownerCollections[to], _id)) {
                ownerCollections[to].push(_id);
            }
        }
//        safeBatchTransferFrom(from, to, ids, numbers, "");
    }

    function collectionDestroy(address from, uint id, uint number) public {
        require(from != address(0), "ERC1155: burn from the zero address");
        uint256 fromBalance = balances[id][from];
        require(fromBalance >= number, "ERC1155: insufficient balance for burn");
        unchecked {
            balances[id][from] = balances[id][from] - number;
        }
        emit TransferSingle(msg.sender, from, address(0), id, number);
        _burn(from, id, number);
    }

    function collectionSynthesis(address user,
        uint[] memory userIds,
        uint[] memory userNumbers,
        address admin,
        uint[] memory adminIds,
        uint[] memory adminNumbers) public {
        batchTransferFrom(user, admin, userIds, userNumbers);
        batchTransferFrom(admin, user, adminIds, adminNumbers);
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(msg.sender != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function balanceOf(address account, uint id) public view override returns (uint){
        return balances[id][account];
    }

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view override returns (uint256[] memory){
        uint256[] memory batchBalances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; i++) {
            batchBalances[i] = balances[ids[i]][accounts[i]];}
        return batchBalances;
    }

    function getNow() public view returns (uint){
        return block.timestamp;
    }
}
