# Coti Node Docker Installation Method

Purpose: Provide an easy method to install, upgrade and maintain Coti nodes using Docker.

This method also provides:

- Automatic SSL certification and renewal
- Automatic upgrades to the latest Coti node version

# Prerequisites

This method needs docker and docker-compose to be installed.

<details>
    <summary>Installation Instructions for Docker and docker-compose on most Linux Operating Systems</summary>

```
sudo su
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
curl -L https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/
```

Check if your installations were successful with

```
docker --version
docker-compose --version
```

</details>

# Installation Instructions

## 1. Clone the Repository

```
git clone https://github.com/tj-wells/coti-node.git && cd coti-node
```

## 2. Define your Environment Variables

The `.env` file defines the environment variables needed to run the Coti node. Start from a <a href="https://github.com/tj-wells/coti-node/blob/master/.env.sample" target="_blank">valid `.env` file</a> by running `cp .env.sample .env`. Environment variables should be specified in the format

```.env
ACTION="<testnet or mainnet>"
SERVERNAME="<Your desired testnet URL>"
PKEY="<Your private key>"
SEED="<Your seed key>"
EMAIL="<Your email address>"
```

where,

- `ACTION` is set to either "testnet" or "mainnet", depending on your use-case.
- `SERVERNAME` is your node's URL in the form "testnet.my-node.com", i.e., including subdomains (where applicable), and excluding 'http(s)://' and 'www.'.
- `PKEY` is your private key. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on obtaining your private key.)
- `SEED` is your wallet's seed. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on generating a seed for your wallet.)
- `EMAIL` is the email address associated with your node.

# Running Your Node

The node can be run in the foreground, which lets you see the logs, with

```
docker-compose up
```

Once you are confident your node is running correctly, you can safely close the terminal window, which leaves the Docker process running. Alternatively, the containers can be run in the background with

```
docker-compose up -d
```

<details>
    <summary>Click to view examples healthy node logs</summary>

Healthy startup logs should look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066373633020272640/Healthy_starting_logs.png"></p>

Healthy steady state logs should look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066373657443700736/Screenshot_2023-01-21_at_15.04.33.png?width=1440&height=572"></p>
</details>

# Automatic Updates

By default, this method configures a service, which checks for new versions of the Coti software, and performs the update for you.

A specific version for your node can be chosen by setting the `VERSION` variable in the `.env` file.

- For example, to fix the version at 3.1.3, add the line `VERSION="3.1.3"` to your .env file.

## Upgrading Manually

Manual upgrades can be performed as follows:

1. Update the new `VERSION` number in your `.env` file
2. Run `docker-compose up` to download and run the new version in the foreground, or `docker-compose up -d` to do so in the background

Please check the <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">Dockerhub registry</a> for a list of the available versions.

# Debugging

Below is a list of common errors/problems that have been encountered when setting up the node software, and their solutions.

- `Timeout during connect (likely firewall problem)`
  - For the SSL verification to work, your server needs to be able to accept incoming connections from the internet on ports 80 and 443.
    To get the SSL certificates installed, you will need to allow all inbound connections (0.0.0.0/0) for ports 80 and 443 to your machine. The precise steps for this will vary depending on your VPS provider.

* My node repeatedly reconnects to the network
  - Coti's node manager performs health status checks on your node using port 7070.
  - To allow the node manager to connect to your node, ensure that port 7070 is accessible from the IP addresses
    - "52.59.142.53" for testnet nodes,
    - "35.157.47.86" for mainnet nodes.

If you encounter issues not in this list, you can ask me (<a href="https://twitter.com/tomjwells">@tomjwells</a>), consult GeordieR's valuable <a href="https://cotidocs.geordier.co.uk/" target="_blank">gitbook guide</a>, or pop your question in the node-operators channel in the [Coti Discord server](https://discord.com/invite/wfAQfbc3Df).

# Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to GeordieR, whose scripts assisted in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# How are the Docker images built?

A separate repository builds the container images which are intended for use by the community.

To ensure that the images are produced in a fully transparent and open-source way, the images are built publicly using Github Actions in <a href="https://github.com/tj-wells/coti-node-images" target="_blank">this repository</a>, and pushed to <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">this Dockerhub registry</a>. All of the code and workflow runs involved in the build process are fully automated, transparent, and can be inspected in the github repository linked above.

# STAY COTI

Stay Coti. ️‍🔥

If you have questions, I hang out on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>. Come and say hi and talk Coti!
<br />
<br />
<br />

<p align="center"><a href="https://twitter.com/tomjwells" target="_blank"><img src="https://cdn.discordapp.com/avatars/343604221331111946/65130831872c9daabdb0d803ce27e594.webp?size=240"></a></p>
