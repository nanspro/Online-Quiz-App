var Quiz = artifacts.require("quiz");

module.exports = function(deployer) {
  deployer.deploy(Quiz, 4, 16);
};