pragma solidity ^0.5.0;

import "../controller/DAO.sol";
import "../controller/DAOController.sol";

contract SpawnController {

    function create(DAO _dao) public returns(address) {
        DAOController controller = new DAOController(_dao);
        // controller.registerScheme(msg.sender, bytes32(0), bytes4(0x0000001f), address(_avatar));
        // controller.unregisterScheme(address(this), address(_avatar));
        return address(controller);
    }
}

