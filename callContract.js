const hre = import('hardhat')
// import abi from './artifacts/contracts/societiez_joining_token.sol/societiez_joining_token.json' assert { type: "json" };

async function main() {

    const [deployer] = await hre.ethers.getSigners();
    const Contract = await hre.ethers.getContractFactory("societiez_joining_token");
    const contract = await Contract.attach("0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0");
    const result = await contract.greet();
    console.log("Contract was called by: ", result);
}
