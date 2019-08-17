let DAOToken = artifacts.require("./DAOToken.sol");
let DAO = artifacts.require("./DAO.sol");  
let DAOController = artifacts.require("./DAOController.sol"); 
let SpawnController = artifacts.require("./SpawnController.sol");
let SpawnDAO = artifacts.require("./SpawnDAO.sol");
let TokenMinter = artifacts.require("./TokenMinter");

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
    console.log("dc: " + dc.address);

    // Mint Tokens
    let mt = await deployer.deploy(TokenMinter, dc.address);
    let tmDeployed = await TokenMinter.deployed();
    console.log("tm: " + tmDeployed.address);

    // Init Default Neurons
    dc.activateNeuron(dc.address, "DAOController", "0x00000010");
    dc.activateNeuron(tmDeployed.address, "TokenMinter", "0x00000010");

    // tmDeployed.MintTokens(da, "0xe7c39B17396ccf22ccAb2EF19d3525Ef231b6920", 1337);
  });
};

  // deployer.deploy(DAOToken, "Infinity", "INI", 1000000, false).then(async function() {
  //   var DAOTokeni = DAOToken.deployed(DAOToken.address);
  //   await deployer.deploy(DAO, "DAOZero", DAO.address);
  //   await deployer.deploy(DAOController, DAO.address);
  // });

// 1. Controller Creator 
// 2. DAO Creator: ForgeOrg
// 3. DAO -> DAOToken: (Avatar)
// 4. Voting Machines
// 5. Global Constraints 
// 6. Schemes 
// 7. Set Schemes
// 8. UController


// deployer.deploy(ControllerCreator, {gas: constants.ARC_GAS_LIMIT}).then(async function(){
//   var controllerCreator = await ControllerCreator.deployed();

//   await deployer.deploy(DaoCreator,controllerCreator.address, {gas: constants.ARC_GAS_LIMIT});
//   var daoCreatorInst = await DaoCreator.deployed(controllerCreator.address,{gas: constants.ARC_GAS_LIMIT});
//   // Create DAOstack:

// Get founders accounts
//   await web3.eth.getAccounts(function(err,res) { accounts = res; });
//   founders[0] = accounts[0];

//   var returnedParams = await daoCreatorInst.forgeOrg(orgName, tokenName, tokenSymbol, founders,
//       initTokenInWei, initRepInWei,NULL_ADDRESS,cap,{gas: constants.ARC_GAS_LIMIT});
//   var AvatarInst = await Avatar.at(returnedParams.logs[0].args._avatar);

//   await deployer.deploy(AbsoluteVote,{gas: constants.ARC_GAS_LIMIT});
//   // Deploy AbsoluteVote:
//   var AbsoluteVoteInst = await AbsoluteVote.deployed();