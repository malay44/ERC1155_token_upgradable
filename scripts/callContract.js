async function main() {

const contract = await ethers.getContractFactory("societiez_joining_token_v2");
const Contract = await contract.attach("0x3D185Db1E844a48825C9046BAFF8e97112347014");

const res = await Contract.newPrice(0);
console.log(res.toString());

}

main();