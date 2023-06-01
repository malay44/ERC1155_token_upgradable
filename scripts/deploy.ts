const { ethers, upgrades } = require("hardhat");

async function main() {
  const Contract = await ethers.getContractFactory("societiez_joining_token");
  const contract = await upgrades.deployProxy(Contract);
  await contract.deployed();
  console.log("Box deployed to:", contract.address);
}

main();

//0x73848bb3D4d66298fF96C79B1c249244d8D2Ef01
//0xc1F50A3C31C084911DE0aB6759Eb27bCad77b054