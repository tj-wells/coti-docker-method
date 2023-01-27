<h1 align="center">Coti Docker Installation Method</h1>
<p align="center">An easy method to install, upgrade and maintain Coti nodes using Docker.</p>

<p align="center">
	<a href="https://github.com/tj-wells/coti-node"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/tj-wells/coti-node"></a>
    <a href="https://twitter.com/intent/tweet?text=I+just+installed+my+%23COTI+node+with+%40tomjwells%27+Docker+installation+method.+It+worked+like+a+charm%21+%F0%9F%94%A5%0D%0A%0D%0Ahttps%3A%2F%2Fgithub.com%2Ftj-wells%2Fcoti-node%0D%0A%0D%0A%24COTI+%24DJED+%24SHEN+"><img src="https://randojs.com/images/tweetShield.svg" alt="Tweet" height="20"/></a>
</p><br/>

<p align="center"><a href="https://github.com/tj-wells/coti-node"><img src="https://s9.gifyu.com/images/coti-node-demo-clipped_censored_h264.gif" width="100%" /></a></p><br/>

This method also provides:

- Automatic SSL certificate creation and renewal
- Automatic upgrades to the latest Coti node version

# ⚡ Installation Instructions

This method relies on docker and docker-compose. Expand the instructions below to install these on your system.

<details>
    <summary>Installation Instructions for Docker and docker-compose (on most Linux Operating Systems)</summary>

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
# VERSION="X.Y.Z" # Optional
```

where,

- `ACTION` is set to either "testnet" or "mainnet", depending on your use-case.
- `SERVERNAME` is your node's URL in the form "testnet.my-node.com", i.e., including subdomains (where applicable), and excluding "http(s)://" and "www.".
- `PKEY` is your private key. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on obtaining your private key.)
- `SEED` is your wallet's seed. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on generating a seed for your wallet.)
- `EMAIL` is the email address associated with your node.
- `VERSION` is the version number of the coti-node you would like to run. Note, that leaving this unspecified will automatically use the latest version that is available and provide automatic updates.

# 🏃 Running Your Node

The node can be run in the foreground, which lets you see the logs, with

```
docker-compose up
```

Check that your logs look healthy, and use the dropdown below to compare with if you have any doubts.

<details>
    <summary>Click to view examples of healthy node logs</summary>

Healthy startup logs should eventually look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066373633020272640/Healthy_starting_logs.png"></p>

Healthy steady state logs should look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066399682743505036/Healthy_steady_state_logs.png"></p>
</details>
<br />
Once you are confident your node is running correctly, you can safely close the terminal window. Ctrl+C will stop the container, so the simplest way I have found to detach from docker-compose is to close the terminal window.
<br />
<br />
Alternatively, the containers can be run in the background with

```
docker-compose up -d
```

If you are not attached to the container, and would like to follow the logs without restarting the container, you can do so with

```
docker-compose logs --follow
```

# 🧑‍💻 Debugging

Below is a list of common errors/problems that have been encountered when setting up the node software, and their solutions.

<details>
    <summary>`Timeout during connect (likely firewall problem)`</summary>
For the SSL verification to work, your server needs to be able to accept incoming connections from the internet on ports 80 and 443.
    To get the SSL certificates installed, you will need to allow all inbound connections (0.0.0.0/0) for ports 80 and 443 to your machine. The precise steps for this will vary depending on your VPS provider.

</details>

<details>
    <summary>My node repeatedly reconnects to the network</summary>
  - Coti's node manager performs health status checks on your node using port 7070.
  - To allow the node manager to connect to your node, ensure that port 7070 is accessible from the IP addresses
    - "52.59.142.53" for testnet nodes,
    - "35.157.47.86" for mainnet nodes.

</details>

If you encounter issues not in this list, you can ask me (<a href="https://twitter.com/tomjwells">@tomjwells</a>), consult GeordieR's helpful <a href="https://cotidocs.geordier.co.uk/" target="_blank">gitbook guide</a>, or pop your question in the node-operators channel in the [Coti Discord server](https://discord.com/invite/wfAQfbc3Df).

# Automatic/Manual Updates

By default, this setup performs updates automatically, so that your node stays up to date when new <a href="https://github.com/coti-io/coti-node/releases" target="_blank">Coti releases</a> are made available.

If you want to bypass the automatic updates, you can do so by specifying the version of the node you would like to run. This is done by defining the `VERSION` variable in the `.env` file.

- For example, to run version 3.1.3 of the Coti node, add the line `VERSION="3.1.3"` into your `.env` file.

Please check the <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">Dockerhub registry</a> for a list of the available versions.

## Upgrading Manually

Manual upgrades can be performed as follows:

1. Update the new `VERSION` number in your `.env` file
2. Run `docker-compose up` to download and run the new version in the foreground, or `docker-compose up -d` to do so in the background

# ✨ Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to GeordieR, whose scripts assisted in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# How are the Docker images built?

A separate repository builds the container images, which are intended for use by the community.

To ensure that the images are produced in a fully transparent and open-source way, the images are built publicly using Github Actions in <a href="https://github.com/tj-wells/coti-node-images" target="_blank">this repository</a>, and pushed to <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">this Dockerhub registry</a>. All of the code and workflow runs involved in the build process are fully automated, transparent, and can be inspected in the github repository linked above.

# STAY COTI

Stay Coti. ️‍🔥
<br />
<br />
<br />

If you have questions, I hang out on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>. Come and say hi and talk Coti!
<br />
<br />
<br />

<p align="center"><a href="https://twitter.com/tomjwells" target="_blank"><img src="https://cdn.discordapp.com/avatars/343604221331111946/65130831872c9daabdb0d803ce27e594.webp?size=240"></a></p>
