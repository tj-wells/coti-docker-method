<h1 align="center">Coti Node Docker Installation Method</h1>

<p align="center">A method to install, upgrade and maintain Coti nodes using Docker.</p>
<p align="center">
	<a href="https://github.com/tomjwells/coti-node"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/tomjwells/coti-node"></a>
    <a href="https://twitter.com/intent/tweet?text=I+just+installed+my+%23COTI+node+with+%40tomjwells%27+Docker+installation+method.+It+worked+like+a+charm%21+%F0%9F%94%A5%0D%0A%0D%0Ahttps%3A%2F%2Fgithub.com%2Ftomjwells%2Fcoti-node%0D%0A%0D%0A%24COTI+%24DJED+%24SHEN+"><img src="https://randojs.com/images/tweetShield.svg" alt="Tweet" height="20"/></a>
</p>

This method, provides:

- A node monitor that restarts the node if it becomes disconnected from the Coti network
- Simple upgrades to new Coti node releases
- A+ rated SSL certificates

The video below demonsrates launching a Coti node with Docker:

https://user-images.githubusercontent.com/5472339/233216833-a8843218-c180-4d78-91c4-c6f05d7cb8cf.mov

# Docker Guide

If you're not familiar with Docker, I wrote a more beginner-friendly guide, which is available [here](https://docker.guides.coticommunity.com).

If you have used Docker before, the instructions below should be enough to run your node.

Good luck!

# Instructions

This method relies on having the programs `docker` and `docker-compose` installed. As the root user, `docker` and `docker-compose` can be installed with

```
curl -fsSL https://get.docker.com | bash
```

and

```
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

respectively. You can check if the programs installed correctly by running

```
docker --version
docker-compose --version
```


## 1. Download the Config Files

The command below downloads all of the files you need to run the node

```
git clone https://github.com/tomjwells/coti-node.git && cd coti-node
```

## 2. Create a `.env` File

A `.env` file is an easy way to define the variables used to run your Coti node. You can start from an [example](https://github.com/tomjwells/coti-node/blob/master/.env.sample) `.env` file by running `cp .env.sample .env`, or copy and paste the code snippet below into a new text file called `.env`. The environment variables in the `.env` file should be formatted as,

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
- `PKEY` is your private key. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on obtaining your private key.).
- `SEED` is your wallet's seed. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on generating a seed for your wallet.).
- `EMAIL` is the email address used to register your SSL certificate.

### Optional Variables

Optionally, you may add a `VERSION` variable to your `.env` file, which allows you to define the version of the Coti node to run. If the `VERSION` is not specified, Docker will automatically use the latest version. The version variable can be set as

```.env
VERSION="X.Y.Z"
```

where X.Y.Z is a valid version number in semver notation. A list of the available versions can be found on [Dockerhub](https://hub.docker.com/r/atomnode/coti-node/tags).

# 🏃 Running Your Node

Now you're ready to run your node! Docker containers can be run in the foreground or in the background. The first few times you run your node, I recommend running the container in the foreground so you can check the logs of your node. To do this, run

```
docker-compose up
```

Make sure your logs look healthy, I have provided some sample logs in the screenshots below if you're not sure what to expect.

<details>
    <summary>Click to view examples of healthy node logs</summary>

Healthy startup logs should eventually look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066373633020272640/Healthy_starting_logs.png"></p>

Healthy steady state logs should look like this:

<p align="center"><img src="https://media.discordapp.net/attachments/995792094088155227/1066399682743505036/Healthy_steady_state_logs.png"></p>
</details>
<br />
To detach from a container that is running in the foreground, the best way I have found is to simply close the terminal window, which safely leaves the container running.
<br /><br />

If you are confident your node runs correctly, you can run it in the background with

```
docker-compose up -d
```

You can still follow the logs of a container that's running in the background, with

```
docker-compose logs --follow
```

When using the above command, you can safely stop following the logs by pressing `Ctrl+C`.

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
	If you have made port 7070 accessible to the general internet (which may be useful for debugging), you can verify that port 7070 is working correctly in your browser by entering the url `http://YOUR-NODE-URL:7070/nodeHash`, which should return your node hash. As an example for my node this would be <a href="http://testnet.atomnode.tomoswells.com:7070/nodeHash">http://testnet.atomnode.tomoswells.com:7070/nodeHash</a>. Note: After experimenting I found this not to work consistently in all browsers (due to SSL errors), but it has worked for me reliably in firefox and safari. You can also use the command line program `curl`, for example `curl http://testnet.atomnode.tomoswells.com:7070/nodeHash`.
</details>

# ⚙️ Updating the Coti Node

If you have set the `VERSION` variable in your `.env` file, make sure to adjust that value first. If there is no `VERSION` in your `.env` file, then you don't need to change anything and running the command below will update your node to the latest version. To perform your update, run

```
docker-compose up -d
```

This causes Docker to install either the specified version, or the latest available version.

A complete list of the available versions can be found at [Dockerhub](https://hub.docker.com/r/atomnode/coti-node/tags).

# ✨ Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to [GeordieR](https://twitter.com/Geordie_R), whose scripts helped me in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# 🐳 Which Docker image does this use?

This repository uses a community-built Docker image (there is currently no official image).

To ensure that the images are trustable, the images are built publicly using Github Actions in [this repository](https://github.com/tomjwells/coti-node-images). The images are stored on <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">Dockerhub</a>.

# Stay Coti

Stay Coti. ️‍🔥
<br />
<br />
<br />


<p align="center"><a href="https://atomnode.tomoswells.com" target="_blank"><img src="https://pay.coti.io/nodes/atomnode.png" style="width: 200px"></a></p>
