// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract CrowdFunding{
    struct Campaign{
        address owner;
        string title;
        string description;
        uint target;
        uint deadline;
        uint amountcollected;
        address[] donators;
        mapping(address => uint) donations;
    }

    mapping(uint => Campaign) public campaigns;//unique id of particular campaign

    uint public number_ofcampaigns;

    modifier onlyOwner(uint _id) {
        address _owner = campaigns[_id].owner;
        require(msg.sender == _owner,"you are not the owner of this");
        _;
    }

    function createcampaign(address _owner,string memory _title,string memory _description,uint _target
    ,uint _deadline) external returns(uint){
        require(_deadline > block.timestamp,"the deadline should be later than the current time");
        Campaign storage c=campaigns[number_ofcampaigns];
        c.owner = _owner;
        c.title = _title;
        c.description = _description;
        c.target = _target;
        c.deadline = _deadline;
        number_ofcampaigns++;
        return number_ofcampaigns-1;
    }

    function donate(uint _id ) external payable{
        Campaign storage c = campaigns[_id];
        uint amount = msg.value;
        require(c.deadline > block.timestamp,"the campaign is over");
        require(c.amountcollected <= c.target , "goal reached");
        require(amount > 0,"you cannot donate zero");
        require(msg.sender != c.owner, "you are not the donor");// owner cannot donate to its own campaign 

        
        if(c.donations[msg.sender] == 0){
            c.donators.push(msg.sender);
        }
        c.donations[msg.sender]+=amount;
        c.amountcollected += amount ;
    }

    function withdrawFunds(uint _id) external payable onlyOwner(_id){
        Campaign storage c = campaigns[_id];
        require(c.amountcollected >= c.target ,"goal not reached");
        uint amount = c.amountcollected;
        (bool success , ) = c.owner.call{value:amount}("");// money getting transferred to the owner 
        require(success , "withdrawal failed");

    }


    function getRefund(uint _id) public {
        Campaign storage c = campaigns[_id];
        require(c.amountcollected < c.target , "goal reached so no refund ");
        require(block.timestamp > c.deadline , "the campaign isn't over yet");

        uint donated = c.donations[msg.sender];
        require(donated > 0,"you did't donate anything");

        c.donations[msg.sender] = 0 ;

        (bool sent ,) = payable(msg.sender).call{value: donated}("");
        require(sent, "refund failed");
    }

    function getallCampaigns() public view returns (address[] memory, string[] memory,string[] memory,uint[] memory,
    uint[] memory,uint[] memory){
        address[] memory owners = new address[](number_ofcampaigns);
        string[] memory titles = new string[](number_ofcampaigns);
        string[] memory descs = new string[](number_ofcampaigns);
        uint[] memory targets = new uint[](number_ofcampaigns);
        uint[] memory deadlines = new uint[](number_ofcampaigns);
        uint[] memory collected = new uint[](number_ofcampaigns);

        for(uint i=0 ; i<number_ofcampaigns;i++){
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

    
    function getCurrentblocktimestamp() public view returns (uint){
        return block.timestamp ;
    }
}