const fs = require("fs")
const { ethers, run, network } = require("hardhat")

const scripts = `scripts/launch.json`
const data = fs.readFileSync(scripts, "utf8")
const jsonContent = JSON.parse(data)

let contractAddress
let blockNumber
let Verified = false


async function ConnectaNftDeploy() {
    const constructorParam = jsonContent.constructorParams
    const connectaNft = await hre.ethers.getContractFactory("ConnectaNft")
    const ConnectaNft = await connectaNft.deploy(
        constructorParam.param1,
        constructorParam.param2,
        constructorParam.param3,
        constructorParam.param4,
    )
    await ConnectaNft.deployed()
    console.log("ConnectaNft Deployed to:", ConnectaNft.address)
    contractAddress = ConnectaNft.address
    blockNumber = ConnectaNft.provider._maxInternalBlockNumber
    /// VERIFY
    if (hre.network.name != "hardhat") {
        await ConnectaNft.deployTransaction.wait(6)
        await verify(ConnectaNft.address, [
            constructorParam.param1,
            constructorParam.param2,
            constructorParam.param3,
            constructorParam.param4
        ])
    }
}

async function ConnectaTicketDeploy() {
    const constructorParam = jsonContent.constructorParams

    const ConnectaTicketFactory = await hre.ethers.getContractFactory("ConnectaTicket")
    const ConnectaTicket = await ConnectaTicketFactory.deploy(
        constructorParam.param1,
        constructorParam.param2,
        constructorParam.param3,
        constructorParam.param4,
        constructorParam.param5,
        constructorParam.param6,
    )

    await ConnectaTicket.deployed()
    console.log("ConnectaTicket Deployed to: ", ConnectaTicket.address)

    contractAddress = ConnectaTicket.address
    blockNumber = ConnectaTicket.provider._maxInternalBlockNumber
    
    /// VERIFY
    if (hre.network.name != "hardhat") {
        await ConnectaTicket.deployTransaction.wait(6)
        await verify(ConnectaTicket.address, [
            constructorParam.param1,
            constructorParam.param2,
            constructorParam.param3,
            constructorParam.param4,
            constructorParam.param5,
            constructorParam.param6
        ])
    }
}

async function main() {
    // ConnectaNft CONTRACT
    if (jsonContent.contractName == "ConnectaNft") {
        await ConnectaNftDeploy()
    }

    if (jsonContent.contractName == "ConnectaTicket") {
        await ConnectaTicketDeploy()
    }
    /// ERC20 
    if (jsonContent.contractName == "Token") {
        await Token()
    }


    let chainId

    if (network.config.chainId != undefined) {
        chainId = network.config.chainId
    } else {
        chainId = network.config.networkId
    }

    console.log(`The chainId is ${chainId}`)
    const data = { chainId, contractAddress, Verified, blockNumber }
    const jsonString = JSON.stringify(data)
    // Log the JSON string
    console.log(jsonString)
}

// async function verify(contractAddress, args) {
const verify = async (contractAddress, args) => {
    console.log("Verifying contract...")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
        Verified = true
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already Verified!")
        } else {
            console.log(e)
        }
    }
}

// main
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
