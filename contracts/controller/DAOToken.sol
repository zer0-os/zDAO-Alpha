pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract DAOToken is ERC20, Ownable  {

    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public cap;
    bool isTransferable;

    uint256 public transactions;

    event received(string msg);

    constructor(string memory _name, string memory _symbol, uint256 _cap, bool _isTransferable) public {
        name = _name;
        symbol = _symbol;
        cap = _cap;
        isTransferable = _isTransferable;

        Mint(0xe7c39B17396ccf22ccAb2EF19d3525Ef231b6920, 50000);
    }

    function Mint(address _to, uint256 _amount) public onlyOwner returns(bool) {
        if (cap > 0)
            require(totalSupply().add(_amount) <= cap, "Error: totalSupply() cannot exceed cap");
        _mint(_to, _amount);
        return true;
    }

    function Burn(uint256 _amount) public onlyOwner returns(bool) {
        _burn(msg.sender, _amount);
        return true;
    }

    function BurnFrom(address _account, uint256 _amount) public onlyOwner returns(bool) {
        _burnFrom(_account, _amount);
    }

    function() external payable {
        transactions = msg.value;
        emit received("transfer received");
    }
}