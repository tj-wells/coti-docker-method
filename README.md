# Coti Node Docker Installation Method

Purpose: Provide an easy method to install, upgrade and maintain Coti nodes, with automatic SSL certification, using Docker containers.

# Installation Instructions

## 1. Install Docker

This method requires that you have docker and docker-compose installed.

Instructions for Ubuntu 22.04 LTS are given below, for other OSs you'll have to search for instructions yourself.

<details>
    <summary>Docker and docker-compose instructions for Ubuntu 22.04 LTS</summary>
    If you are working on Ubuntu 22.04, I found the following commands useful:

```
# Install docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce

# Install docker-compose
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
docker compose version
```

</details>

## 2. Clone the Repository

```
git clone https://github.com/tj-wells/coti-node.git && cd coti-node
```

## 3. Define your Environment

The `.env` file defines the environment variables needed for the Coti node to run. These should be specified in the format

```.env
ACTION="<testnet or mainnet>"
SERVERNAME="<Your desired testnet URL>"
PKEY="<Your private key>"
SEED="<Your seed key>"
VERSION="X.Y.Z"
EMAIL="<Your email address>"
```

where,

- ACTION is set to either of the values "testnet" or "mainnet", depending on your use-case.
- SERVERNAME is your desired testnet URL is in the form "testnet.my-node.com", i.e., including subdomains where applicable, and without 'http(s)://' and 'www.'.
- PKEY is your private key. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on obtaining your private key.)
- SEED is your wallet's seed. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on generating a seed for your wallet.)
- VERSION should be in the format "X.Y.Z", where X, Y and Z are digits, for example, "3.1.2". See the list below for the versions currently available for installation.
- EMAIL is the email address associated with your node.

An example .env file, <a href="https://github.com/tj-wells/coti-node/blob/master/.env.sample" target="_blank">.env.sample</a>, is provided in the repository. You may copy it to start from a valid template file: `cp .env.sample .env`.

### Available Node Versions

Available Coti Node Versions:

<ul>
  <li>3.1.3</li>
  <li>3.1.2</li>
</ul>

# Running Your Node

The node can be run in the foreground, which lets you see the logs, with

```
docker-compose up
```

Once you are confident your node is running correctly, you can safely close the terminal window, which leaves the Docker process running. Alternatively, the containers can be run in the background with

```
docker-compose up -d
```

Depending on your OS and version of docker-compose, the `docker-compose` syntax may need to be modified to `docker compose`.

# Upgrading Your Node Version

Upgrading your Coti node version is easy using Docker, and can be done in the following two steps:

1. Update the new version number in your .env file
2. Run `docker-compose up` to download and run the new version in the foreground, or `docker-compose up -d` to do so in the background

# How are the Docker images built?

Since Coti do not produce Docker images, I have set up a separate repository to build container images for the community.

To ensure that the images are produced in a fully transparent and open-source way, the images are built publicly using Github Actions in <a href="https://github.com/tj-wells/coti-node-images" target="_blank">this repository</a>, and pushed to <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">this Dockerhub registry</a>. All of the code and workflow runs involved in the build process are fully automated, transparent, and can be inspected in the github repository linked above.

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

If none of the information above helps, you can ask me (<a href="https://twitter.com/tomjwells">@tomjwells</a>), consult GeordieR's valuable <a href="https://cotidocs.geordier.co.uk/" target="_blank">gitbook guide</a>, or to get help from the community, pop a question in the node-operators channel in the [Coti Discord server](https://discord.com/invite/wfAQfbc3Df).

# Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to GeordieR, whose scripts assisted in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# STAY COTI

Stay Coti. ️‍🔥

If you have questions, I hang out on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>. Come and say hi and talk Coti!
<br />
<br />
<br />

<p align="center"><a href="https://twitter.com/tomjwells" target="_blank"><img src="https://cdn.discordapp.com/avatars/343604221331111946/65130831872c9daabdb0d803ce27e594.webp?size=240"></a></p>
