pragma solidity >=0.4.17 < 0.7.0;

import "./EnecoToken.sol";

contract EnecoTokenSale
{
    address admin;
    EnecoToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(EnecoToken _tokenContract, uint256 _tokenPrice) public
    {
        // Assign an admin
        admin = msg.sender;
        // Token Contract
        tokenContract = _tokenContract;
        // Token Price
        tokenPrice = _tokenPrice;
    }

    // Multiply
    function multiply(uint x, uint y) internal pure returns (uint z)
    {
        require(y == 0 || (z = x * y) / y == x, 'Invalid Operations');
    }

    // Buy Tokens
    function buyTokens(uint256 _numberOfTokens) public payable
    {
        // Require that value is equal to tokens
        require(msg.value == multiply(_numberOfTokens, tokenPrice), "Values must equal");
        // Require that contract has enough tokens
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "Contract doesn't have enough tokens");
        // Require that transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens), "Transfer isn't successful");

        // Keep track of number of tokens sold
        tokensSold += _numberOfTokens;
        // Trigger Sell Event
        emit Sell(msg.sender, _numberOfTokens);
    }
}