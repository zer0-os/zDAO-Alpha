pragma solidity ^0.5.0;

import "./Choice.sol";
import "./ChoiceType.sol";
import "../controller/DAO.sol";
import "../controller/DAOController.sol";


contract MintTokenChoice { 

    DAO dao;
    DAOToken daoToken;
    DAOController daoController;
    MintTokenChoice mtc;
    
    Choice choice = new Choice(dao, daoToken, mtc);

    event MintTokensEvent(DAO _dao, address _beneficiary, uint256 _amount);

    struct MintTokensToAddress {
        address benefiary;
        uint256 amount;
    }

    MintTokensToAddress mintTokensToAddress;

    constructor(DAO _dao, DAOToken _daoToken, address _beneficiary, uint256 _amount) public {
        dao = _dao;
        daoToken = _daoToken;
        mintTokensToAddress.benefiary = _beneficiary;
        mintTokensToAddress.amount = _amount;
    }

    function approveChoice(DAO _dao) public returns(bool) {
        daoController.mintTokens(_dao, mintTokensToAddress.benefiary, mintTokensToAddress.amount);
        emit MintTokensEvent(_dao, mintTokensToAddress.benefiary, mintTokensToAddress.amount);
        return true;
    }
}