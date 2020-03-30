pragma solidity >=0.4.17 < 0.7.0;

/**
    Token for the Cleanergy network
 */
contract EnecoToken
{
    // Name
    string public constant name = "Eco-Energy Token";
    // Symbol
    string public constant symbol = "ENECO";
    // Standard Version
    string public standard = "Eco-Energy Token v1.0";
    uint256 public totalSupply;

    // The event that the token is transferred
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // The event that a transaction is approved
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Balances of all the accounts
    mapping(address => uint256) public balanceOf;
    // Transactions in which spender is still allowed to withdraw from owner
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply) public
    {
        totalSupply = _initialSupply;

        // Allocate initial supply
        balanceOf[msg.sender] = _initialSupply;
    }

    // View the total supply
    function totalTokens() public view returns (uint256)
    {
        return totalSupply;
    }

    // Transfer Tokens
    function transfer(address _to, uint256 _value) public returns (bool success)
    {
        // Exception if account doesn't have enough
        require(balanceOf[msg.sender] >= _value, "There are not enough tokens in your balance!");
        // Transfer the balance
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        // Transfer Event
        emit Transfer(msg.sender, _to, _value);
        // Return a boolean
        return true;
    }

    // Approve Transaction
    function approve(address _spender, uint256 _value) public returns (bool success)
    {
        // Allowance
        allowance[msg.sender][_spender] = _value;
        // Approval Event
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Delegated Transfer
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    {
        // Require enough tokens to transfer
        require(_value <= balanceOf[_from], "There are not enough tokens to transfer!");
        // Require tokens to be no greater than the approved amount
        require(_value <= allowance[_from][msg.sender], "Transfer value cannot be greater than approved amount");
        // Change balance
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        // Update allowance
        allowance[_from][msg.sender] -= _value;
        // Transfer Event
        emit Transfer(_from, _to, _value);
        return true;
    }
}