pragma solidity ^0.5.0;

import "../controller/DAO.sol";

contract ChoiceType {
    function approveChoice(DAO _dao, string memory status) public returns(bool);
}