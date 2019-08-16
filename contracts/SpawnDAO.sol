pragma solidity ^0.5.0;

import "./DAO.sol";
import "./DAOToken.sol";
import "./SpawnController.sol";

contract SpawnDAO {

    SpawnController public spawnController;
    address public daoController;

    constructor(SpawnController _spawnController) public {
        spawnController = _spawnController;
    }

    function spawn(
        bytes32 _daoName,
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

    // a private function is called here due to a stack error

    function _spawn (
        bytes32 _daoName,
        string memory _tokenName,
        string memory _tokenSymbol,
        bool _isTransferable,
        uint256 _cap
    ) private returns(address)
    {
        // Create Token and Avatar:
        DAOToken daoToken = new DAOToken(_tokenName, _tokenSymbol, _cap, false);
        DAO dao = new DAO(_daoName, daoToken);

        // Mint token and reputation for Stewards:

        // Create Controller:
        daoController = spawnController.create(dao);

        // Transfer ownership:
        daoToken.transferOwnership(address(daoController));
        dao.transferOwnership(address(daoController));

        return (address(dao));
    }
}