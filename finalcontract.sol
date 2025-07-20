// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CrowdFunding is ReentrancyGuard {

    event CampaignCreated(uint campaignId, address indexed creator, uint target, uint deadline);
    event ContributionReceived(uint indexed campaignId, address indexed contributor, uint amount);
    event Refunded(uint indexed campaignId, address indexed contributor, uint amount);
    event FundsWithdrawn(uint indexed campaignId, address indexed owner, uint amount);

    struct Campaign {
        address owner;
        string title;
        string description;
        uint target;
        uint deadline;
        uint amountcollected;
        address[] donators;
        mapping(address => uint) donations;
    }

    mapping(uint => Campaign) public campaigns;
    uint public number_ofcampaigns;

    modifier onlyOwner(uint _id) {
        require(msg.sender == campaigns[_id].owner, "You are not the owner");
        _;
    }

    function createcampaign(
        string memory _title,
        string memory _description,
        uint _target,
        uint _duration
    ) external returns (uint) {
        require(_target > 0, "Target must be greater than 0");
        require(_duration > 0, "Duration must be positive");

        Campaign storage c = campaigns[number_ofcampaigns];
        c.owner = msg.sender;
        c.title = _title;
        c.description = _description;
        c.target = _target * 1 ether;
        c.deadline = block.timestamp + _duration;

        emit CampaignCreated(number_ofcampaigns, msg.sender, c.target, c.deadline);

        number_ofcampaigns++;
        return number_ofcampaigns - 1;
    }

    function donate(uint _id) external payable nonReentrant {
        Campaign storage c = campaigns[_id];
        require(c.deadline > block.timestamp, "Campaign is over");
        require(c.amountcollected < c.target, "Goal already reached");
        require(msg.value > 0, "Donation must be positive");

        if (c.donations[msg.sender] == 0) {
            c.donators.push(msg.sender);
        }

        c.donations[msg.sender] += msg.value;
        c.amountcollected += msg.value;

        emit ContributionReceived(_id, msg.sender, msg.value);
    }

    function withdrawFunds(uint _id) external onlyOwner(_id) nonReentrant {
        Campaign storage c = campaigns[_id];
        require(block.timestamp > c.deadline, "Campaign still ongoing");
        require(c.amountcollected >= c.target, "Goal not reached");
        require(c.amountcollected > 0, "No funds to withdraw");

        uint amount = c.amountcollected;
        c.amountcollected = 0;

        (bool success, ) = c.owner.call{value: amount}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(_id, msg.sender, amount);
    }

    function getRefund(uint _id) external nonReentrant {
        Campaign storage c = campaigns[_id];
        require(block.timestamp > c.deadline, "Campaign still ongoing");
        require(c.amountcollected < c.target, "Goal reached, no refund");
        uint donated = c.donations[msg.sender];
        require(donated > 0, "Nothing to refund");

        c.donations[msg.sender] = 0;

        (bool sent, ) = payable(msg.sender).call{value: donated}("");
        require(sent, "Refund failed");

        emit Refunded(_id, msg.sender, donated);
    }

    function getallCampaigns() public view returns (
        address[] memory,
        string[] memory,
        string[] memory,
        uint[] memory,
        uint[] memory,
        uint[] memory
    ) {
        address[] memory owners = new address[](number_ofcampaigns);
        string[] memory titles = new string[](number_ofcampaigns);
        string[] memory descs = new string[](number_ofcampaigns);
        uint[] memory targets = new uint[](number_ofcampaigns);
        uint[] memory deadlines = new uint[](number_ofcampaigns);
        uint[] memory collected = new uint[](number_ofcampaigns);

        for (uint i = 0; i < number_ofcampaigns; i++) {
            Campaign storage c = campaigns[i];
            owners[i] = c.owner;
            titles[i] = c.title;
            descs[i] = c.description;
            targets[i] = c.target;
            deadlines[i] = c.deadline;
            collected[i] = c.amountcollected;
        }

        return (owners, titles, descs, targets, deadlines, collected);
    }

    function getCurrentblocktimestamp() public view returns (uint) {
        return block.timestamp;
    }
}
