var ShenzhenTong = artifacts.require("./ShenzhenTong.sol");

module.exports = function(deployer) {
  deployer.deploy(ShenzhenTong, 10);
};