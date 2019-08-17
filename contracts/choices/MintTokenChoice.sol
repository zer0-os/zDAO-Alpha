pragma solidity ^0.5.0;

import "./Choice.sol";
import "./ChoiceType.sol";
import "../controller/DAO.sol";
import "../controller/DAOController.sol";


contract MintTokenChoice is ChoiceType {

    DAO public dao;
    DAOToken public daoToken;
    DAOController public daoController;
    Choice choice;
    address choiceAddress;

    event MintTokensEvent(DAO _dao, address _beneficiary, uint256 _amount);

    struct MintTokensToAddress {
        address beneficiary;
        uint256 amount;
        string status;
    }

    MintTokensToAddress mintTokensToAddress;

    constructor(DAO _dao, DAOToken _daoToken, address _beneficiary, uint256 _amount) public {
        dao = _dao;
        daoToken = _daoToken;
        mintTokensToAddress.beneficiary = _beneficiary;
        mintTokensToAddress.amount = _amount;
        mintTokensToAddress.status = "proposed";
        choice = new Choice(dao, daoToken, 1, address(this));
    }

    function getChoiceAddress() public view returns(address) {
        return choice.getAddress();
    }

    function getBeneficiary() public view returns(address, uint256, string memory) {
        return(mintTokensToAddress.beneficiary, mintTokensToAddress.amount, mintTokensToAddress.status);
    }

    function approveChoice(DAO _dao, string memory _status) public returns(bool) {
        mintTokensToAddress.status = _status;
        // daoController.mintTokens(_dao, mintTokensToAddress.beneficiary, mintTokensToAddress.amount);
        emit MintTokensEvent(_dao, mintTokensToAddress.beneficiary, mintTokensToAddress.amount);
        return true;
    }
}