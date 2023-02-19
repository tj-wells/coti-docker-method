<h1 align="center">Coti Node Docker Installation Method</h1>

<p align="center">An easy method to install, upgrade and maintain Coti nodes using Docker.</p>
<p align="center">
	<a href="https://github.com/tj-wells/coti-node"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/tj-wells/coti-node"></a>
    <a href="https://twitter.com/intent/tweet?text=I+just+installed+my+%23COTI+node+with+%40tomjwells%27+Docker+installation+method.+It+worked+like+a+charm%21+%F0%9F%94%A5%0D%0A%0D%0Ahttps%3A%2F%2Fgithub.com%2Ftj-wells%2Fcoti-node%0D%0A%0D%0A%24COTI+%24DJED+%24SHEN+"><img src="https://randojs.com/images/tweetShield.svg" alt="Tweet" height="20"/></a>
</p>

<!-- <p align="center"><a href="https://github.com/tj-wells/gif/blob/master/coti-node-demo-clipped_censored_1080p.gif"><img src="https://media.discordapp.net/attachments/995792094088155227/1070494059610767400/header_img_white-01.png?width=1300&height=825" width="100%" /></a></p><br/> -->

This method also provides:

- Automatic SSL certificate creation and renewal
- Automatic upgrades to the latest Coti node version

Watch how easy launching a node with Docker is below (click for high-resolution):

<p align="center"><a href="https://github.com/tj-wells/gif/blob/master/coti-node-demo-clipped_censored_1080p.gif"><img src="https://raw.githubusercontent.com/tj-wells/gif/master/coti-node-demo-clipped_censored_1080p.gif" width="100%" /></a></p><br/>

# Installation Instructions

This method relies on the programs `docker` and `docker-compose`. To install them, expand the instructions below.

<details>
    <summary>Installation Instructions for Docker and docker-compose (on most Linux Operating Systems)</summary>

```
sudo su
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
curl -L https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

Run the following commands to make sure your installations were successful

```
docker --version
docker-compose --version
```

</details>

## 1. Clone the Repository

```
git clone https://github.com/tj-wells/coti-node.git && cd coti-node
```

## 2. Create a `.env` File

The `.env` file defines the environment variables used to configure the Coti node. You can start from a <a href="https://github.com/tj-wells/coti-node/blob/master/.env.sample" target="_blank">valid `.env` file</a> by running `cp .env.sample .env`, or copy and paste the code snippet below into a text file called `.env`. Environment variables should be specified in the format

```.env
ACTION="<mainnet or testnet>"
SERVERNAME="<Your desired mainnet or testnet URL>"
PKEY="<Your private key>"
SEED="<Your seed key>"
EMAIL="<Your email address>"
```

where,

- `ACTION` is set to either "testnet" or "mainnet", depending on your use-case.
- `SERVERNAME` is your node's URL in the form "testnet.my-node.com", i.e., including subdomains (where applicable), and excluding "http(s)://" and "www.".
- `PKEY` is your private key. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on obtaining your private key.)
- `SEED` is your wallet's seed. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on generating a seed for your wallet.)
- `EMAIL` is the email address associated with your node.

### Optional Variables

Adding a `VERSION` variable to your `.env` file disables the automatic updates, and allows you to run your node on a specific version. The version variable should be specified in semver notation, as

```.env
VERSION="X.Y.Z"
```

Check <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">Dockerhub</a> for the available versions.

## 3. Create a Docker Network

A Docker network called `gateway` is required to help route requests within your machine. To create the network, run

```
docker network create --driver=bridge --attachable --internal=false gateway
```

Once this network is created, there is normally no need to create it again. You can check if it has been created by running `docker network ls`.

# 🏃 Running Your Node

Now you're ready to run your node! To watch the logs of your node, you should run your node in the foreground. To do this, run

```
docker-compose up
```

Make sure your logs look healthy, and compare your logs with the screenshots in the dropdown below if you have doubts.

<details>
    <summary>Click to view examples of healthy node logs</summary>

Healthy startup logs should eventually look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066373633020272640/Healthy_starting_logs.png"></p>

Healthy steady state logs should look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066399682743505036/Healthy_steady_state_logs.png"></p>
</details>
<br />
Once you are confident your node is running correctly, you can safely close the terminal window. Ctrl+C will stop the container, so the simplest way I have found to detach from docker-compose is to close the terminal window, which leaves the container running.
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

When you're not attached to the container, you can safely stop following the logs by pressing `Ctrl+C`.

# 🧑‍💻 Debugging

Below is a list of common errors/problems that have been encountered when setting up the node software, and their solutions.

<details>
    <summary>`Timeout during connect (likely firewall problem)`</summary>

<br/>
For the SSL verification to work, your server needs to be able to accept incoming connections from the internet on ports 80 and 443.
<br/>
    To get the SSL certificates installed, you will need to allow all inbound connections (0.0.0.0/0) for ports 80 and 443 to your machine. The precise steps for this will vary depending on your VPS provider.
<br/>
<br/>
</details>
<details>
    <summary>My node is repeatedly reconnecting to the network</summary>
    Coti's node manager performs health status checks on your node using port 7070.<br/>
    To allow the node manager to connect to your node, ensure that port 7070 is accessible from the IP addresses:
    <ul>
    <li>"52.59.142.53" for testnet nodes,</li>
    <li>"35.157.47.86" for mainnet nodes.</li>
    </ul>
</details>
<details>
    <summary>`While lock file: ./FullNoderocksDB1/LOCK: Resource temporarily unavailable`</summary>
    This error can occur if the Coti container is stopped abruptly.<br/>
    The solution is to remove the `LOCK` file:
    <ul>
    <li>`rm /var/lib/docker/volumes/coti-node_coti_db/_data/LOCK` - to remove the LOCK file directly, or</li>
    <li>`docker volume rm coti-node_coti_db` - to remove the Docker volume</li>
    </ul>
</details>
<br />

If you encounter issues not mentioned in this list, please message me (<a href="https://twitter.com/tomjwells">@tomjwells</a>), consult GeordieR's helpful <a href="https://cotidocs.geordier.co.uk/" target="_blank">gitbook guide</a>, or post your question in the node-operators channel in the [Coti Discord server](https://discord.com/invite/wfAQfbc3Df).

# ⚙️ Updating the Coti Node Version

If you have not specified a version number, this setup will perform updates automatically, ensuring that your node stays up to date when new <a href="https://github.com/coti-io/coti-node/releases" target="_blank">Coti releases</a> are made available.

Automatic updates can be bypassed by specifying a `VERSION` number in the `.env` file.

- For example, if you wanted run version 3.1.3 of the Coti node, you would add the line `VERSION="3.1.3"` into your `.env` file.

A complete list of the available versions can be found in the <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">Dockerhub registry</a>.

## Upgrading Manually

Manual upgrades can be performed as follows:

1. Modify the `VERSION` number in your `.env` file to the version you'd like to run
2. Run `docker-compose up` to update in the foreground, or `docker-compose up -d` to update in the background

# ✨ Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to <a href="https://github.com/Geordie-R" target="_blank">GeordieR</a>, whose scripts assisted in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# 🐳 How are the Docker images built?

As Coti does not currently produce official Docker images, this method uses a community-built Docker image.

To ensure that the images are produced in a fully transparent and open-source way, the images are built publicly using Github Actions in <a href="https://github.com/tj-wells/coti-node-images" target="_blank">this repository</a>, and pushed to <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">this Dockerhub registry</a>. All of the code and workflow runs involved in the build process are automated, transparent, and can be inspected in the github repository linked to above.

# 🧑‍🔬 How can I monitor my node?

Using Docker makes it easy to add other applications to your node. <a href="https://github.com/tj-wells/coti-node-monitoring" target="_blank">See my guide</a> to easily set up a monitoring dashboard for Coti nodes.

# STAY COTI

Stay Coti. ️‍🔥
<br />
<br />
<br />

If you have questions, I hang out on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>. Come and say hi and talk Coti!
<br />
<br />
<br />

<p align="center"><a href="https://atomnode.tomoswells.com" target="_blank"><img src="https://cdn.discordapp.com/avatars/343604221331111946/65130831872c9daabdb0d803ce27e594.webp?size=240"></a></p>
