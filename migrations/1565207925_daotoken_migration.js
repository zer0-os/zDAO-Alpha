let DAOToken = artifacts.require("./DAOToken.sol");
let DAO = artifacts.require("./DAO.sol");  
let DAOController = artifacts.require("./DAOController.sol"); 
let SpawnController = artifacts.require("./SpawnController.sol");
let SpawnDAO = artifacts.require("./SpawnDAO.sol");
let TokenMinter = artifacts.require("./TokenMinter");
let MintTokenChoice = artifacts.require("./MintTokenChoice");

let daoName = "Zero";
let tokenName = "Infinity";
let tokenSymbol = "INI";
let isTransferable = false;
let cap = "100000000";

module.exports = function(deployer) {
  // Init Base Controller
  deployer.deploy(SpawnController).then(async function() {
    // Init SpawnDAO
    var spawnController = await SpawnController.deployed();
    await deployer.deploy(SpawnDAO, spawnController.address);

    // Init DAO with DAOToken
    var spawnDAO = await SpawnDAO.deployed();
    await spawnDAO.spawn(daoName, tokenName, tokenSymbol, isTransferable, cap);
    
    // Init Controller for DAO
    let initDaoController = await spawnDAO.daoController();
    let daoController = await DAOController.at(initDaoController);

    // Mint Tokens
    await deployer.deploy(TokenMinter, daoController.address);
    let tokenMinter = await TokenMinter.deployed();

    // Init Default Neurons
    daoController.activateNeuron(daoController.address, "DAOController", "0x00000010");
    daoController.activateNeuron(tokenMinter.address, "TokenMinter", "0x00000010");    

    // Init Choice
    let mintTokenChoice = await deployer.deploy(MintTokenChoice, daoController.address, "0xe7c39B17396ccf22ccAb2EF19d3525Ef231b6920", 3457);

    // Contract Addresses
    await console.log("DAOController: " + daoController.address);
    await console.log("DAOToken: " + await daoController.daoToken());
    await console.log("DAO: " + await daoController.dao());
    await console.log("TokenMinter: " + tokenMinter.address);
    await console.log("MintTokenChoice: " + await mintTokenChoice.address);
    await console.log("SpawnController: " + spawnController.address);
    await console.log("SpawnDAO: " + spawnDAO.address);
  });
};