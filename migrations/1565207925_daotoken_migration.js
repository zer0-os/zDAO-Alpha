let DAOToken = artifacts.require("./DAOToken.sol");
let DAO = artifacts.require("./DAO.sol");  
let DAOController = artifacts.require("./DAOController.sol"); 
let SpawnController = artifacts.require("./SpawnController.sol");
let SpawnDAO = artifacts.require("./SpawnDAO.sol") ;

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

    // Init Default Neurons
    dc.activateNeuron("0xe7c39B17396ccf22ccAb2EF19d3525Ef231b6920", "red", "0x00000008");
    dc.activateNeuron("0xAf7e9f4b769092d8beeBc9A2330624F63e4271f1", "blue", "0x00000012");
    dc.activateNeuron("0xbf5cbdE7fDF0b5fA09ce61E50Ad46632a09312E9", "green", "0x00000012");
    dc.activateNeuron("0x9A2761D41F437818D2027442D89c4D056Ddc77Ae", "cyan", "0x00000012");
    dc.activateNeuron("0xf100ad39337A0191482A65A4A80EDb709e9128cC", "purple", "0x00000012");
    dc.activateNeuron("0xFB8D16e71B21d5a889612aE16e7872A4de0Fcd98", "pink", "0x00000012");
    dc.activateNeuron("0x54fE623b2a3f5580a4bCB7579248b409C2540e50", "black", "0x00000012");
    console.log(dc.address);
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