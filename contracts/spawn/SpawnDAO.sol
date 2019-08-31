pragma solidity ^0.5.0;

import "../controller/DAO.sol";
import "../controller/DAOToken.sol";
import "./SpawnController.sol";

contract SpawnDAO {

    SpawnController public spawnController;
    address public daoController;

    constructor(SpawnController _spawnController) public {
        spawnController = _spawnController;
    }

    function spawn(
        string calldata _daoName,
        string calldata _tokenName,
        string calldata _tokenSymbol,
        bool _isTransferable,
        uint256 _cap
    ) external returns(address) {
        return _spawn(
            _daoName,
            _tokenName,
            _tokenSymbol,
            _isTransferable,
            _cap);
    }

    function _spawn (
        string memory _daoName,
        string memory _tokenName,
        string memory _tokenSymbol,
        bool _isTransferable,
        uint256 _cap
    ) private returns(address)
    {
        // Create Token and DAO:
        DAOToken daoToken = new DAOToken(_tokenName, _tokenSymbol, _cap, false);
        DAO dao = new DAO(_daoName, daoToken);

        // Mint initial token for Stewards:

        // Create Controller:
        daoController = spawnController.create(dao);

        // Transfer Ownership:
        daoToken.transferOwnership(address(daoController));
        dao.transferOwnership(address(daoController));

        return (address(dao));
    }
}