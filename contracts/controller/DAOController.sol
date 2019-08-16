pragma solidity ^0.5.0;

import "./DAO.sol";
import "../spawn/SpawnDAO.sol";

contract DAOController {

    struct Neuron {
        string neuronName;
        address neuronAddress;
        uint listPointer;
        bytes4 permissions;
    }

    DAO public dao;
    DAOToken public valueToken;
    DAOToken public votingToken;

    mapping(address => Neuron) neurons;
    address[] public neuronList;

    // event AddGlobalConstraint(address indexed _globalConstraint, bytes32 _params, GlobalConstraintInterface.CallPhase _when);
    // event RemoveGlobalConstraint(address indexed _globalConstraint, uint256 _index, bool _isPre);
    event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
    event BurnTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
    event ActivateNeuron (address indexed _sender, address indexed _neuron);
    event DeactivateNeuron (address indexed _sender, address indexed neuron);
    // event UpgradeController(address indexed _oldController, address _newController);

    constructor(DAO _dao) public {
        dao = _dao;
        valueToken = dao.valueToken();
        votingToken = dao.votingToken();
    }

    function getName() public view PermissionToTransferToken() returns (bytes32) {
        return dao.daoName();
    }


    function getNeurons() public view returns(address[] memory) {
        return neuronList;
    }

    function getNeuron(address _neuronAddress) public view returns (string memory, uint, bytes4) {
        return(neurons[_neuronAddress].neuronName, neurons[_neuronAddress].listPointer, neurons[_neuronAddress].permissions);
    }

    function activateNeuron (address _neuronAddress, string calldata _neuronName, bytes4 _permissions) external returns(bool) {
        neurons[_neuronAddress].neuronAddress = _neuronAddress;
        neurons[_neuronAddress].neuronName = _neuronName;
        neurons[_neuronAddress].permissions = _permissions;
        neuronList.push(_neuronAddress);
        neurons[_neuronAddress].listPointer = neuronList.length-1;
        emit ActivateNeuron (msg.sender, _neuronAddress);
        return true;
    }

    function deactivateNeuron(address _neuronAddress) external returns(bool) {
        uint rowToDelete = neurons[_neuronAddress].listPointer;
        address rowToMove = neuronList[neuronList.length-1];
        neuronList[rowToDelete] = rowToMove;
        neurons[rowToMove].listPointer = rowToDelete;
        neuronList.length--;
        delete neurons[_neuronAddress];
        emit DeactivateNeuron(msg.sender, _neuronAddress);
        return true;
    }

    function mintTokens(address _avatar, address _beneficiary, uint256 _amount)
    external
    returns(bool)
    {
        emit MintTokens(msg.sender, _beneficiary, _amount);
        return valueToken.Mint(_beneficiary, _amount);
    }

    // burn burnTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);

    function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
    external
    returns(bool)
    {
        return dao.externalTokenTransfer(_externalToken, _to, _value);
    }

    function externalTokenTransferFrom(IERC20 _externalToken, address _from, address _to, uint256 _value)
    external
    PermissionToTransferToken()
    returns(bool)
    {
        return dao.externalTokenTransferFrom(_externalToken, _from, _to, _value);
    }

    function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
    external
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

    modifier PermissionToApproveToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010), "Permission Error: PermissionToApproveToken");
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

}