pragma solidity ^0.5.0;

import "./DAOToken.sol";

contract DAO is Ownable {

    bytes32 public daoName;
    DAOToken public daoToken;

    event SendEther(address indexed _to, uint256 _amountInWei);
    event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
    event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
    event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
    event ReceiveEther(address indexed _sender, uint256 _value);

    constructor(bytes32 _daoName, DAOToken _daoToken) public {
        daoName = _daoName;
        daoToken = _daoToken;
    }

    function() external payable {
        emit ReceiveEther(msg.sender, msg.value);
    }
    function sendEther(address payable _to, uint256 _amountInWei)
    public onlyOwner returns(bool) { //add back OnlyOwner
        _to.transfer(_amountInWei);
        emit SendEther(_to, _amountInWei);
        return true;
    }

    function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
    public onlyOwner returns(bool)
    {
        daoToken.transfer(_to, _value);
        emit ExternalTokenTransfer(address(_externalToken), _to, _value);
        return true;
    }

    function externalTokenTransferFrom(IERC20 _externalToken, address _from, address _to, uint256 _value)
    public onlyOwner returns(bool)
    {
        daoToken.transferFrom(_from, _to, _value);
        emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
        return true;
    }

    function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
    public onlyOwner returns(bool)
    {
        daoToken.approve(_spender, _value);
        emit ExternalTokenApproval(address(_externalToken), _spender, _value);
        return true;
    }
}