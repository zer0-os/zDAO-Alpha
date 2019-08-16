pragma solidity ^0.5.0;

import "../controller/DAOController.sol";
import "../controller/DAO.sol";

contract TokenMinter {

    DAOController public daoController;

    constructor(DAOController _daoController) public {
        daoController = _daoController;
    }

    event MintTokensEvent(address _dao, address _beneficiary, uint256 _amount);

    function MintTokens(address _dao, address _beneficiary, uint256 _amount) public returns(bool) {
        daoController.mintTokens(_dao, _beneficiary, _amount);
        emit MintTokensEvent(_dao, _beneficiary, _amount);
        return true;
    }
}