const { ethers, upgrades } = require("hardhat");

async function main() {
  const Contract = await ethers.getContractFactory("societiez_joining_token");
  const contract = await upgrades.deployProxy(Contract, {constructorArgs: ["0xf0511f123164602042ab2bCF02111fA5D3Fe97CD"]});
  await contract.deployed();
  console.log("Box deployed to:", contract.address);
}

main();

//0x73848bb3D4d66298fF96C79B1c249244d8D2Ef01
//0xc1F50A3C31C084911DE0aB6759Eb27bCad77b054
//0x02ED078A4d907a0038D27617971Ef9639a0F5590 -- gasless implemented 
//0x622CD18891b985bd6509Ef37b0BB36Fb1f473EC6 -- gasless implemented -- 2nd deployment
//0x626d096156Da47F6e69677d1D399eC984414D8b8 -- gasless implemented -- 3rd deployment
//0x5635D901fA1331839322f6f9486bf1c5538B872f -- gasless implemented -- 4th deployment