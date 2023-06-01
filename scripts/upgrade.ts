const { ethers, upgrades } = require('hardhat');

async function main () {
  const contractV2 = await ethers.getContractFactory('societiez_joining_token_v2');
  console.log('Upgrading Contract...');
  const upgraded_contrat = await upgrades.upgradeProxy("0x3D185Db1E844a48825C9046BAFF8e97112347014", contractV2);
  console.log('Contract upgraded to:', upgraded_contrat.address);
}

main();

export {};