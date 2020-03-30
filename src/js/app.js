App = 
{
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() 
  {
    return App.initWeb3();
  },

  initWeb3: function() 
  {
    if (typeof web3 !== 'undefined') 
    {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } 
    else 
    {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() 
  {
    $.getJSON("EnecoToken.json", function(token) 
    {
      // Instantiate a new truffle contract from the artifact
      App.contracts.EnecoToken = TruffleContract(token);
      // Connect provider to interact with contract
      App.contracts.EnecoToken.setProvider(App.web3Provider);

      App.listenForEvents();
      return App.render();
    });
  },

  render: function() 
  {
    var tokenInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function(err, account) 
    {
      if (err === null) 
      {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.EnecoToken.deployed().then(function(instance) 
    {
      tokenInstance = instance;
      return tokenInstance.totalTokens();
    }).then(function(totalTokens) 
    {
      $("#totalTokens").append(totalTokens);
    });
  },

  donateTokens: function()
  {
    var recipient = $("#recipient").val();
    var tokenAmount = $("#tokenAmount").val();
    App.contracts.EnecoToken.deployed().then(function(instance)
    {
      return instance.transferFrom(App.account, recipient, tokenAmount);
    }).then(function(result)
    {
      // Wait for transactions to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err)
    {
      console.error(err);
    });
  },

  listenForEvents: function()
  {
    App.contracts.EnecoToken.deployed().then(function(instance)
    {
      instance.transferEvent({},
        {
          fromBlock: 0,
          toBlock: 'latest'
        }).watch(function(error, event)
        {
          console.log("transfer event triggered", event);

          // Reload when tokens are transferred
          App.render();
        });
    });

    App.contracts.EnecoToken.deployed().then(function(instance)
    {
      instance.approvalEvent({},
        {
          fromBlock: 0,
          toBlock: 'latest'
        }).watch(function(error, event)
        {
          console.log("approval event triggered", event);
        });

          // Reload when transactions are approved
          App.render();
    })
  }
};

$(function() 
{
  $(window).load(function() 
  {
    App.init();
  });
});