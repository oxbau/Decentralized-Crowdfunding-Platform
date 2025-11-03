# Decentralized Crowdfunding Platform

A decentralized application (DApp) that allows users to create and contribute to crowdfunding campaigns, built on the Ethereum blockchain. This project serves as a practical example of how smart contracts can be used to create trustless and transparent crowdfunding platforms.

## Features

-   **Create Campaigns:** Users can create a new crowdfunding campaign by providing a title, description, funding goal, and a deadline.
-   **Contribute to Campaigns:** Anyone can contribute Ether to any active campaign.
-   **Disburse Funds:** If a campaign successfully reaches its funding goal by the deadline, the creator of the campaign can withdraw the collected funds.
-   **Refunds:** If a campaign does not meet its funding goal by the deadline, contributors can withdraw their contributions.
-   **Trustless:** The entire process is managed by the smart contract, eliminating the need for a central intermediary.

## How It Works

The `Crowdfunding` smart contract manages all the logic for creating campaigns, accepting contributions, and handling the disbursement of funds or refunds.

-   Each campaign is represented by a `struct` that stores its details, including the creator's address, goal, deadline, and the amount raised.
-   The `createCampaign` function allows anyone to launch a new campaign.
-   The `contribute` function allows users to send Ether to a specific campaign.
-   After the deadline, if the goal is met, the `disburseFunds` function allows the creator to receive the funds.
-   If the goal is not met, the `getRefund` function allows contributors to get their money back.

## Getting Started

### Prerequisites

-   [Node.js](https://nodejs.org/)
-   [Hardhat](https://hardhat.org/) or [Truffle](https://www.trufflesuite.com/)

### Installation and Deployment

1.  **Clone the repository:**
    ```bash
    git clone [your-repo-link]
    cd [your-repo-name]
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    ```
3.  **Compile the contract:**
    ```bash
    npx hardhat compile
    ```
4.  **Deploy to a local network:**
    ```bash
    npx hardhat node
    npx hardhat run --network localhost scripts/deploy.js
    ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
