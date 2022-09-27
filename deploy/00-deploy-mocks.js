const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");

module.exports = async function ({ getNamedAcccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAcccounts();
    const chainId = network.config.chainId;

    if ( developmentChains.includes(network.name)){
        log("Local network detected! Deploying mocks...")
        //deploy mock vrfcoordinator... 
    }

};
