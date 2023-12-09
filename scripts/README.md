# LAUCH CONTRACT'S

## **Contract Deployment Parameters**

This README file provides an overview of how to fetch contract deployment parameters from a JSON file. The JSON file contains the contract name and constructor parameters required for deploying different contracts. This guide assumes you have a basic understanding of JSON and contract deployment.

## **JSON Format**

The JSON file should have the following format:

**Caution** : Only the parameters should be altered for deployment, not the contract's name in json examples.

`Connecta Contract`

```shell
{
    "contractName" : "ConnectaNft",
    "constructorParams":{
        "param1" : "Soul Wizard",
        "param2" : "SW",//Symbol
        "param3" : "www.xyz.com", 
        "param4" : "0xb4f7ba8C7d818a208Cd89B127a126DD2aa45aDae"
    }
}
```

The `contracts` array contains objects representing each contract. Each contract object has two properties:

-   `contractName`: The name of the contract.
-   `constructorParams`: An array of constructor parameters for the contract.

## **Fetching Parameters**

To fetch the contract deployment parameters from the JSON file, we preferred programming language and JSON parsing library. Here's an example in JavaScript:

```shell
const fs = require("fs")

const scripts = `scripts/deploy/deploy.json`
const data = fs.readFileSync(scripts, "utf8")
const jsonContent = JSON.parse(data)

```

Make sure to replace `scripts` with the path to your actual JSON file.

## **Deploying Contracts**

Once you have fetched the contract deployment parameters, you can use them to deploy the contracts using your preferred method or framework. The deployment process will depend on the specific blockchain platform you are using (e.g., Ethereum, Binance Smart Chain, etc.) and the development tools you have chosen (e.g., Truffle, Hardhat, etc.).

Please refer to the documentation or resources provided by your chosen platform and development tools for detailed instructions on deploying contracts programmatically.

To launch the contracts using current Json file , use command

```shell
yarn launch --network $NETWORK
```

or

For local deployement

```shell
yarn launch
```

## **Conclusion**

This guide has provided an overview of how to fetch contract deployment parameters from a JSON file. By following these steps, you can easily retrieve the contract name and constructor parameters required for deploying different contracts programmatically.
