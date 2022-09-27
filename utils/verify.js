const { run } = require("hardhat");

const verify = async (contractAddress, args) => {
    console.log("Verifying contract...");

    //since our code may already be verified which may cause an error , we use a try catch
    try {
        //below is the verify function
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        });
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already verified");
        } else {
            console.log(e);
        }
    }
};

module.exports = { verify };
