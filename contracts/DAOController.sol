pragma solidity ^0.5.0;

import "./DAO.sol";
import "./SpawnDAO.sol";

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

    // event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
    // event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
    event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
    // event RegisterScheme (address indexed _sender, address indexed _scheme);
    // event UnregisterScheme (address indexed _sender, address indexed _scheme);
    // event UpgradeController(address indexed _oldController, address _newController);
    // event AddGlobalConstraint(address indexed _globalConstraint, bytes32 _params, GlobalConstraintInterface.CallPhase _when);
    // event RemoveGlobalConstraint(address indexed _globalConstraint, uint256 _index, bool _isPre);

    constructor(DAO _dao) public {
        dao = _dao;
        valueToken = dao.valueToken();
        votingToken = dao.votingToken();
        //schemes[msg.sender] = Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001F)});
    }

    function getName() public view PermissionToTransferToken() returns (bytes32) {
        return dao.daoName();
    }


    function getNeurons() view public returns(address[] memory) {
        return neuronList;
    }

    function getNeuron(address _neuronAddress) view public returns (string memory, uint, bytes4) {
        return(neurons[_neuronAddress].neuronName, neurons[_neuronAddress].listPointer, neurons[_neuronAddress].permissions);
    }

    function activateNeuron (address _neuronAddress, string calldata _neuronName, bytes4 _permissions) external returns(bool) {
        neurons[_neuronAddress].neuronAddress = _neuronAddress;
        neurons[_neuronAddress].neuronName = _neuronName;
        neurons[_neuronAddress].permissions = _permissions;
        neuronList.push(_neuronAddress);
        neurons[_neuronAddress].listPointer = neuronList.length-1;
        return true;
    }

    function deactivateNeuron(address _neuronAddress) external returns(bool) {
        uint rowToDelete = neurons[_neuronAddress].listPointer;
        address rowToMove = neuronList[neuronList.length-1];
        neuronList[rowToDelete] = rowToMove;
        neurons[rowToMove].listPointer = rowToDelete;
        neuronList.length--;
        delete neurons[_neuronAddress];
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

    function externalTokenTransfer(address _to, uint256 _value)
    external
    returns(bool)
    {
        return dao.externalTokenTransfer(_to, _value);
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
        require(neurons[msg.sender].neuronAddress == msg.sender);
        _;
    }

    modifier PermissionToMintToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
        _;
    }

    modifier PermissionToBurnToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
        _;
    }

    modifier PermissionToTransferToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
        _;
    }

    modifier PermissionToApproveToken() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
        _;
    }

    modifier PermissionToActivateNeuron() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
        _;
    }

    modifier PermissionToDeactivateNeuron() {
        require(neurons[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
        _;
    }

}