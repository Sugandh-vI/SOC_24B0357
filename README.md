# SOC_24B0357

SOC-2025

On Chain Crowdfunding Platform

INTRODUCTION - During the Seasons of Code program, I worked on building an on-chain crowdfunding platform. This project not only introduced 
me to the exciting world of blockchain technology but also helped me develop a range of technical and conceptual skills, particularly around 
decentralized applications and smart contract development.

KEY LEARNINGS -

1. Understanding Blockchain Technology

I began my journey by understanding the fundamentals of blockchain—how it functions as a distributed, immutable ledger, and how blocks are 
linked using cryptography. I explored how this decentralized approach enhances transparency and trust in digital transactions.

2. Blockchain and Cryptography

I delved into the cryptographic principles that secure blockchain systems, such as hashing, digital signatures, and public-private key 
encryption. This knowledge helped me appreciate how data integrity and user authentication are handled in decentralized systems.

3. Introduction to Decentralized Applications (DApps)

Next, I learned about DApps, which run on peer-to-peer networks like Ethereum. I understood their architecture, how they differ from traditional apps, and their benefits—like censorship resistance and increased reliability.

4. Learning Solidity

I then learned Solidity, the primary language for writing smart contracts on the Ethereum blockchain. Starting from basic concepts like data types and functions, I gradually moved to more advanced topics such as modifiers, mappings, and access control.

a. State Variables and Data Types

Solidity supports various data types like uint, address, bool, and arrays. State variables are used to store data on the blockchain.

b. Constructor Function

A constructor is a special function that runs once when the contract is deployed. 

c. Modifiers for Access Control

Modifiers are reusable code blocks that can be applied to functions. I used them to restrict certain functions to only the contract owner.

d. Mapping and Structs for Data Storage

To manage contributors and their donations, I used struct to define a contributor and mapping to store them.

e. Payable Functions to Handle Ether

Solidity provides the payable keyword to allow contracts to receive Ether. I used it for contributors to fund a campaign.

f. Private–only inside contract, Internal–only inside contract and child contract, Public–inside and outside contract, External–only from outside contract

g. SOME GLOBAL VARIABLES-

* msg.sender - msg.sender represents the address of the account (either user or contract) that called the function.It’s frequently used for access control (e.g., ensuring only the owner can execute specific actions).

* msg.value - msg.value holds the amount of Ether (in wei) sent along with a transaction.It's only relevant in payable functions.

* block.timestamp - block.timestamp returns the Unix timestamp of the current block (i.e., when the block was mined).Useful for timing-based logic (e.g., deadlines) .

These concepts together enabled me to write a fully functional, secure, and gas-efficient smart contract for my crowdfunding platform. I tested these contracts using Remix IDE and gained confidence in debugging and deploying Solidity code.




