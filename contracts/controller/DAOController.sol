pragma solidity ^0.5.0;

import "./DAO.sol";
import "./DAOToken.sol";
import "../spawn/SpawnDAO.sol";
import "../spawn/SpawnController.sol";

contract DAOController {

    struct Neuron {
        string neuronName;
        address neuronAddress;
        DAOToken neuronToken;
        uint listIndex;
        bytes4 permissions;
    }

    DAO public dao;
    DAOToken public daoToken;
    address public daoController;

    mapping(address => Neuron) neurons;
    address[] public neuronList;

    event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
    event BurnTokens (address indexed _sender, uint256 _amount);
    event BurnTokensFrom (address indexed _sender, address indexed _account, uint256 _amount);
    event ActivateNeuron (address indexed _sender, address indexed _neuron);
    event DeactivateNeuron (address indexed _sender, address indexed neuron);

    constructor(DAO _dao) public {
        dao = _dao;
        daoToken = dao.daoToken();
    }

    function getName() public view PermissionToTransferToken() returns (string memory) {
        return dao.daoName();
    }

    function getNeurons() public view returns(address[] memory) {
        return neuronList;
    }

    function getNeuron(address _neuronAddress) public view returns (string memory, uint, bytes4) {
        return(neurons[_neuronAddress].neuronName, neurons[_neuronAddress].listIndex, neurons[_neuronAddress].permissions);
    }

    function activateNeuron (address _neuronAddress, string calldata _neuronName, bytes4 _permissions)
    external
    // PermissionToActivateNeuron()
    returns(bool) {
        neurons[_neuronAddress].neuronAddress = _neuronAddress;
        neurons[_neuronAddress].neuronName = _neuronName;
        neurons[_neuronAddress].permissions = _permissions;
        neuronList.push(_neuronAddress);
        neurons[_neuronAddress].listIndex = neuronList.length-1;
        emit ActivateNeuron (msg.sender, _neuronAddress);
        return true;
    }

    function deactivateNeuron(address _neuronAddress)
    external
    PermissionToDeactivateNeuron()
    returns(bool) {
        uint rowToDelete = neurons[_neuronAddress].listIndex;
        address rowToMove = neuronList[neuronList.length-1];
        neuronList[rowToDelete] = rowToMove;
        neurons[rowToMove].listIndex = rowToDelete;
        neuronList.length--;
        delete neurons[_neuronAddress];
        emit DeactivateNeuron(msg.sender, _neuronAddress);
        return true;
    }

    function mintTokens(DAO _dao, address _beneficiary, uint256 _amount)
    external
    // PermissionToMintToken()
    returns(bool)
    {
        emit MintTokens(msg.sender, _beneficiary, _amount); //add isvalidDao
        return daoToken.Mint(_beneficiary, _amount);
    }

    function burnTokens (address _dao, uint256 _amount)
    external //add isvalidDao
    PermissionToBurnToken()
    returns(bool)
    {
        emit BurnTokens(msg.sender, _amount);
        return daoToken.Burn(_amount);
    }

    function burnTokensFrom (address _dao, address _account, uint256 _amount)
    external //add isvalidDao
    PermissionToBurnToken()
    returns(bool)
    {
        emit BurnTokensFrom(msg.sender, _account, _amount);
        return daoToken.BurnFrom(_account, _amount);
    }

    function externalTokenTransfer(DAOToken _externalToken, address _to, uint256 _value)
    external
    PermissionToBurnToken()
    returns(bool)
    {
        return dao.externalTokenTransfer(_externalToken, _to, _value);
    }

    function externalTokenTransferFrom(DAOToken _externalToken, address _from, address _to, uint256 _value)
    external
    PermissionToTransferTokenFrom()
    returns(bool)
    {
        return dao.externalTokenTransferFrom(_externalToken, _from, _to, _value);
    }

    function externalTokenApproval(DAOToken _externalToken, address _spender, uint256 _value)
    external
    PermissionToApproveToken()
    returns(bool)
    {
        return dao.externalTokenApproval(_externalToken, _spender, _value);
    }

    // Need to Implement: upgradeController

    // Modifiers

    modifier isActiveNeuron() {
        require(neurons[msg.sender].neuronAddress == msg.sender, "Permissiono Error: Neuron not Active");
        _;
    }

    modifier PermissionToActivateNeuron() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToActivateNeuron");
        _;
    }

    modifier PermissionToDeactivateNeuron() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToDeactivateNeuron");
        _;
    }

    modifier PermissionToMintToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToMintToken");
        _;
    }

    modifier PermissionToBurnToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToBurnToken");
        _;
    }

    modifier PermissionToTransferToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToTransferToken");
        _;
    }

    modifier PermissionToTransferTokenFrom() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToTransferTokenFrom");
        _;
    }

    modifier PermissionToApproveToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToApproveToken");
        _;
    }
}