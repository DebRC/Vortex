require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
    solidity: "0.8.20",
    networks: {
        eth: {
            url: process.env.RPC_URL,
            accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2, process.env.PRIVATE_KEY_3],
        },
        vortex: {
            url: process.env.RPC_URL_VORTEX,
            accounts: [process.env.PRIVATE_KEY_VORTEX],
        },
        
    },
};
