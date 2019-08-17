let DAOToken = artifacts.require("./DAOToken.sol");
let DAO = artifacts.require("./DAO.sol");  
let DAOController = artifacts.require("./DAOController.sol"); 
let SpawnController = artifacts.require("./SpawnController.sol");
let SpawnDAO = artifacts.require("./SpawnDAO.sol");
let TokenMinter = artifacts.require("./TokenMinter");
let Choice = artifacts.require("./Choice");
let MintTokenChoice = artifacts.require("./MintTokenChoice");

let daoName = "0x44414f0000000000000000000000000000000000000000000000000000000000";
let tokenName = "Infinity";
let tokenSymbol = "INI";
let isTransferable = false;
let cap = "100000000"; //0xz84595161401484A000000


module.exports = function(deployer) {
  // Init Base Controller
  deployer.deploy(SpawnController).then(async function() {
    // Init SpawnDAO
    var spawnController = await SpawnController.deployed();
    await deployer.deploy(SpawnDAO, spawnController.address);

    // Init DAO with DAOToken
    var spawnDAO = await SpawnDAO.deployed();
    var returnedParams = await spawnDAO.spawn(daoName, tokenName, tokenSymbol, isTransferable, cap);
    
    // Init Controller for DAO
    let da = await spawnDAO.daoController();
    let dc = await DAOController.at(da);


    // Mint Tokens
    let mt = await deployer.deploy(TokenMinter, dc.address);
    let tmDeployed = await TokenMinter.deployed();


    // Init Default Neurons
    dc.activateNeuron(dc.address, "DAOController", "0x00000010");
    dc.activateNeuron(tmDeployed.address, "TokenMinter", "0x00000010");

    // tmDeployed.MintTokens(da, "0xe7c39B17396ccf22ccAb2EF19d3525Ef231b6920", 1337);
    
    
    //Deploy Choice
    let daoToken = await dc.daoToken();
    let dao = await dc.dao();

    // let DAOTokenInstance = await DAOToken.at(daoToken);
    // let DAOInstance = await DAO.at(dao);

    let mintTokenChoice = await deployer.deploy(MintTokenChoice, dao, daoToken, dc.address, "0xe7c39B17396ccf22ccAb2EF19d3525Ef231b6920", 3457);
    // let choiceInstance = await deployer.deploy(Choice, dao, daoToken, 1, mintTokenChoice.address);

    //Console.log
    let a = await console.log("dc: " + dc.address);
    let b = await console.log("tm: " + tmDeployed.address);
    let c = console.log("dt: " + await dc.daoToken());
    let d = console.log("dao: " + await dc.dao());
    // let e = console.log("c: " + await choiceInstance.address);
    let f = console.log("mtc: " + await mintTokenChoice.address);
    // let g = console.log(DAOInstance);

  });
};