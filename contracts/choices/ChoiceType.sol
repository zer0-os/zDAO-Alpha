pragma solidity ^0.5.0;

import "../controller/DAO.sol";

contract ChoiceType {

    DAO public dao;
    DAOToken public daoToken;

    constructor(DAO _dao, DAOToken _daoToken) public {
        dao = _dao;
        daoToken = _daoToken;
    }

    function approveChoice(DAO _dao) public returns(bool) {
        dao = _dao;
        return true;
    }
}