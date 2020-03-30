var EnecoToken = artifacts.require("./EnecoToken.sol");
var EnecoTokenSale = artifacts.require("./EnecoTokenSale.sol")

module.exports = function(deployer) 
{
  deployer.deploy(EnecoToken, 1000000).then(function()
  {
    // Price is 0.001 Ether
    var tokenPrice = 1000000000000000 // in Wei subdivision of Ether

    return deployer.deploy(EnecoTokenSale, EnecoToken.address, tokenPrice);
  });
};
