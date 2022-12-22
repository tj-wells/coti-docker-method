<p align="center"><img src="https://cdn.discordapp.com/avatars/343604221331111946/65130831872c9daabdb0d803ce27e594.webp?size=240"></p>

# COTI Node Docker Installation Method

Purpose: Provide an easy method to install, upgrade and maintain testnet node with Docker containers.

Note: This method is only available for testnet nodes at present.

# Usage Instructions

## 1. Install Docker

This method requires that you have docker and docker-compose installed.

<details>
    <summary>Ubuntu 22.04 LTS Docker and docker-compose installation method.</summary>
    If you are working on Ubuntu 22.04, I suggest installing with the following commands:

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

## 3. Define the Environment

The .env file contains the configuration variables of your node, and should have the format:

```.env
ACTION="testnet"
SERVERNAME="<Your desired testnet URL>"
PKEY="<Your private key>"
SEED="<Your seed key>"
VERSION="<Version coti-node you wish to run>"
EMAIL="<Your email address>"
```

where,

- SERVERNAME is your desired testnet URL is in the format "atom-node.xyz", i.e. without 'http(s)://' and 'www.'.
  - If you want to use a subdomain, included that too, for example, "testnet.your-node.com".
- the version you wish to run to should be in the format "X.Y.Z", for example, "3.1.0". See the dropdown below for the versions available.

An example .env file (.env.sample) is provided in the repository. Copy it to start from a valid template (`cp .env.sample .env`).

### Available Versions

<details>
    <summary>Available COTI Node Versions</summary>
    <ul>
      <li>3.1.0</li>
      <li>3.1.2.RELEASE</li>
    </ul>
</details>

# Running your testnet node

The testnet node can be run in the foreground with

```
docker-compose up
```

This lets you check the logs and make sure the node is working correctly. Once you are confident your node runs correctly, use

```
docker-compose up -d
```
to run the containers in the background.

Depending on your OS and version of docker-compose, the `docker-compose` syntax may need to be changed to `docker compose`.

# Updating Your Node

Follow the instructions below to update the software version being run by your node:

1. Check that the version you would like to update to is listed in the section [Available Versions](#available-versions)
2. Edit the new version number in your .env file
3. Run `docker-compose up -d` to download and run the new version

# Credits

- This method uses the official code for COTI nodes at https://github.com/coti-io/coti-node.
- Credits to the Coti community for their support and guidance shown to node operators.

# Debugging

Below is a list of common errors/problems that have been encountered when setting up the node software, and their solutions.

- `Timeout during connect (likely firewall problem)`
  - For the SSL verification to work, your server needs to be able to accept incoming connections from the internet. For security reasons many cloud providers only allow incoming connections from port 22 (SSH) by default. Since both ports 80 and 443 are used in the installation of the SSL certificates, you will need to allow all inbound connections (0.0.0.0/0) for ports 80 and 443 to your machine.

* My node repeatedly reconnects to the network
  - COTI's node manager performs health status checks on your node using port 7070.
  - To pass the health checks, ensure that port 7070 is accessible to the IP address "52.59.142.53" for testnet nodes, and "35.157.47.86" for mainnet nodes.

- If none of the documentation above helps, you can ask me, check GeordieR's <a href="https://cotidocs.geordier.co.uk/" target="_blank">gitbook guide</a>, or to get help from the community, ask in the node-operators channel in the [COTI discord server](https://discord.com/invite/wfAQfbc3Df).

# STAY COTI

Stay Coti.

If you have questions, I hang out a lot on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>. It would be great to say hi and talk Coti!
