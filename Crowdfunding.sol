// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Crowdfunding {
    struct Campaign {
        address payable creator;
        string title;
        string description;
        uint256 goal;
        uint256 deadline;
        uint256 amountRaised;
        mapping(address => uint256) contributors;
        bool completed;
    }

    Campaign[] public campaigns;
    uint256 public campaignCount;

    event CampaignCreated(
        uint256 id,
        address indexed creator,
        string title,
        uint256 goal,
        uint256 deadline
    );
    event Contribution(
        uint256 indexed id,
        address indexed contributor,
        uint256 amount
    );
    event FundsDisbursed(uint256 indexed id, address indexed creator, uint256 amount);
    event CampaignFailed(uint256 indexed id, uint256 amountRaised);

    modifier onlyCreator(uint256 _id) {
        require(
            msg.sender == campaigns[_id].creator,
            "Only the creator can call this function."
        );
        _;
    }

    modifier afterDeadline(uint256 _id) {
        require(
            block.timestamp >= campaigns[_id].deadline,
            "The deadline has not been reached yet."
        );
        _;
    }

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _goal,
        uint256 _deadline
    ) public returns (uint256) {
        require(_goal > 0, "Goal must be greater than 0.");
        require(_deadline > block.timestamp, "Deadline must be in the future.");

        Campaign storage newCampaign = campaigns.push();
        newCampaign.creator = payable(msg.sender);
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.goal = _goal;
        newCampaign.deadline = _deadline;
        newCampaign.completed = false;

        uint256 newCampaignId = campaignCount;
        campaignCount++;

        emit CampaignCreated(newCampaignId, msg.sender, _title, _goal, _deadline);
        return newCampaignId;
    }

    function contribute(uint256 _id) public payable {
        require(_id < campaignCount, "Campaign does not exist.");
        Campaign storage campaign = campaigns[_id];

        require(!campaign.completed, "Campaign has already been completed.");
        require(
            block.timestamp < campaign.deadline,
            "The campaign has ended."
        );
        require(msg.value > 0, "Contribution must be greater than 0.");

        campaign.contributors[msg.sender] += msg.value;
        campaign.amountRaised += msg.value;

        emit Contribution(_id, msg.sender, msg.value);
    }

    function getRefund(uint256 _id) public {
        require(_id < campaignCount, "Campaign does not exist.");
        Campaign storage campaign = campaigns[_id];

        require(
            block.timestamp >= campaign.deadline,
            "The deadline has not been reached yet."
        );
        require(
            campaign.amountRaised < campaign.goal,
            "The campaign was successful, no refunds."
        );
        require(
            campaign.contributors[msg.sender] > 0,
            "You are not a contributor to this campaign."
        );

        uint256 contributionAmount = campaign.contributors[msg.sender];
        campaign.contributors[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{
            value: contributionAmount
        }("");
        require(success, "Refund failed.");
    }

    function disburseFunds(uint256 _id)
        public
        onlyCreator(_id)
        afterDeadline(_id)
    {
        require(_id < campaignCount, "Campaign does not exist.");
        Campaign storage campaign = campaigns[_id];

        require(
            !campaign.completed,
            "Funds for this campaign have already been disbursed."
        );
        require(
            campaign.amountRaised >= campaign.goal,
            "The campaign did not meet its goal."
        );

        campaign.completed = true;
        uint256 amountToDisburse = campaign.amountRaised;

        (bool success, ) = campaign.creator.call{value: amountToDisburse}("");
        require(success, "Failed to disburse funds.");

        emit FundsDisbursed(_id, campaign.creator, amountToDisburse);
    }

    function getCampaign(uint256 _id)
        public
        view
        returns (
            address,
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            bool
        )
    {
        require(_id < campaignCount, "Campaign does not exist.");
        Campaign storage campaign = campaigns[_id];
        return (
            campaign.creator,
            campaign.title,
            campaign.description,
            campaign.goal,
            campaign.deadline,
            campaign.amountRaised,
            campaign.completed
        );
    }
}
