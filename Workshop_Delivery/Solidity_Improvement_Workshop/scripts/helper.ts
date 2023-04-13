import * as fs from "fs";
import { HardhatRuntimeEnvironment } from "hardhat/types";

export const readAddressList = function () {
  return JSON.parse(fs.readFileSync("address.json", "utf-8"));
};

export const storeAddressList = function (addressList: object) {
  fs.writeFileSync("address.json", JSON.stringify(addressList, null, "\t"));
};

export const getAddress = function (network: string, key: string) {
  const addressList = readAddressList();
  return addressList[network][key];
};

export const storeAddress = function (
  network: string,
  key: string,
  address: string
) {
  const addressList = readAddressList();
  addressList[network][key] = address;
  console.log(`Deployed ${key} to: ${address}`);
  storeAddressList(addressList);
};

export const verifyingContract = async function (
  hre: HardhatRuntimeEnvironment,
  contractAddress: string,
  constructorArguments: string[] = []
) {
  const { network } = hre;
  if (network.name === "hardhat") return;
  await hre.run("verify:verify", {
    address: contractAddress,
    constructorArguments: constructorArguments,
  });
  console.log(`${contractAddress} verified!`);
};
