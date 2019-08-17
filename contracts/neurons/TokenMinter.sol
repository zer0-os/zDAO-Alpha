pragma solidity ^0.5.0;

import "../controller/DAO.sol";
import "../controller/DAOController.sol";

contract TokenMinter {

    DAO public dao;
    DAOController public daoController;

    constructor(DAOController _daoController) public {
        daoController = _daoController;
    }

    event MintTokensEvent(DAO _dao, address _beneficiary, uint256 _amount);

    function MintTokens(DAO _dao, address _beneficiary, uint256 _amount) public returns(bool) {
        daoController.mintTokens(_dao, _beneficiary, _amount);
        emit MintTokensEvent(_dao, _beneficiary, _amount);
        return true;
    }
}