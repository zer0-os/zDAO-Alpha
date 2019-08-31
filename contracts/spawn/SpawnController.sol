pragma solidity ^0.5.0;

import "../controller/DAO.sol";
import "../controller/DAOController.sol";

contract SpawnController {

    function create(DAO _dao) public returns(address) {
        DAOController controller = new DAOController(_dao);
        return address(controller);
    }
}