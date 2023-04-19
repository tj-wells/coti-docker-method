<h1 align="center">Coti Node Docker Installation Method</h1>

<p align="center">A method to easily install, upgrade and maintain Coti nodes using Docker.</p>
<p align="center">
	<a href="https://github.com/tomjwells/coti-node"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/tomjwells/coti-node"></a>
    <a href="https://twitter.com/intent/tweet?text=I+just+installed+my+%23COTI+node+with+%40tomjwells%27+Docker+installation+method.+It+worked+like+a+charm%21+%F0%9F%94%A5%0D%0A%0D%0Ahttps%3A%2F%2Fgithub.com%2Ftomjwells%2Fcoti-node%0D%0A%0D%0A%24COTI+%24DJED+%24SHEN+"><img src="https://randojs.com/images/tweetShield.svg" alt="Tweet" height="20"/></a>
</p>

<!-- <p align="center"><a href="https://github.com/tomjwells/gif/blob/master/coti-node-demo-clipped_censored_1080p.gif"><img src="https://media.discordapp.net/attachments/995792094088155227/1070494059610767400/header_img_white-01.png?width=1300&height=825" width="100%" /></a></p><br/> -->

This method also provides:

- Automatic A+ SSL certificates
- Easy upgrades to new Coti node releases

The video below shows an example of launching a Coti node with Docker:

https://user-images.githubusercontent.com/5472339/233216833-a8843218-c180-4d78-91c4-c6f05d7cb8cf.mov

# Installation Instructions

This method relies on having the programs `docker` and `docker-compose` installed. They can be installed using the commands below.

```
sudo su
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
curl -L https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

You can check if your installations were successful using

```
docker --version
docker-compose --version
```


## 1. Clone the Repository

The contents of this repository can be downloaded to your machine using

```
git clone https://github.com/tomjwells/coti-node.git && cd coti-node
```

## 2. Create a `.env` File

A `.env` file is used to define the variables used to run your Coti node. You can start from an [example](https://github.com/tomjwells/coti-node/blob/master/.env.sample) `.env` file by running `cp .env.sample .env`, or copy and paste the code snippet below into a text file called `.env`. Environment variables should be specified in the format

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
- `EMAIL` is the email address used to register your SSL certificate

### Optional Variables

Adding a `VERSION` variable to your `.env` file disables the automatic updates, and allows you to run your node on a specific version. The version variable should be as

```.env
VERSION="X.Y.Z"
```

A list of the available versions can be found on [Dockerhub](https://hub.docker.com/r/atomnode/coti-node/tags). If the version is not specified, Docker will use the latest available release.

## 3. Create a Docker Network

A Docker network called `gateway` helps route requests within your machine. To create the network, run

```
docker network create --driver=bridge --attachable --internal=false gateway
```

Once this network is created, there is normally no need to create it again. You can check if it has been created by running `docker network ls`.

# 🏃 Run Your Node

Now you're ready to run your node! Docker containers can be run in the foreground or in the background. The first few times you run your node, I recommend you run the container in the foreground so you can watch the logs of your node. To do this, run

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
To detach from a container that is running in the foreground, the best way I have found is to simply close the terminal window, which safely leaves the container running.
<br /><br />

If you are confident your node runs correctly, you can run it in the background with

```
docker-compose up -d
```

You can still follow the logs of a container that's running a background, with

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
<br />

If you encounter issues not mentioned in this list, please message me (<a href="https://twitter.com/tomjwells">@tomjwells</a>), consult GeordieR's helpful <a href="https://cotidocs.geordier.co.uk/" target="_blank">gitbook guide</a>, or post your question in the node-operators channel in the [Coti Discord server](https://discord.com/invite/wfAQfbc3Df).

# ⚙️ Updating the Coti Node Version

If you have not specified a version number, this setup performs updates automatically, ensuring that your node stays up to date with the latest [Coti release](https://github.com/coti-io/coti-node/releases).

However, I understand that mainnet operators are often asked not to run the latest version and thus may want to control the updating themselves. Automatic updates can be bypassed by specifying a `VERSION` number in the `.env` file. Instructions for performing updates manually are provided below.

- For example, if you wanted run version 3.1.3 of the Coti node, you would add the line `VERSION="3.1.3"` into your `.env` file.

A complete list of the available versions can be found at [Dockerhub](https://hub.docker.com/r/atomnode/coti-node/tags).

## Upgrading Manually

Manual upgrades can be performed as follows:

1. Modify the `VERSION` number in your `.env` file to the version you'd like to run
2. Run `docker-compose up` to update in the foreground, or `docker-compose up -d` to update in the background

## Upgrading through a Web Interface

If you don't want automatic updates, but also don't want the inconvenience of logging into your server to make manual upgrades, there is a good solution for this problem. It is possible to use a service called Portainer, which manages Docker containers running on a server from a web interface. If you want to run your node this way, check my [coti-node-portainer](https://github.com/tomjwells/coti-node-portainer) repository.

# ✨ Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to <a href="https://github.com/Geordie-R" target="_blank">GeordieR</a>, whose scripts assisted in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# 🐳 What Docker image is being used?

As there currently is no official Docker image, this method uses a community-built Docker image.

To ensure that the images are produced in a fully transparent and open-source way, the images are built publicly using Github Actions in <a href="https://github.com/tomjwells/coti-node-images" target="_blank">this repository</a>, and pushed to <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">this Dockerhub registry</a>.

# 🧑‍🔬 How can I monitor my node?

Using Docker makes it easy to add other applications to your node. <a href="https://github.com/tomjwells/coti-node-monitoring" target="_blank">See my guide</a> for setting up a monitoring dashboard for Coti nodes.

# STAY COTI

Stay Coti. ️‍🔥
<br />
<br />
<br />

If you have questions, I hang out on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>. Come and say hi and talk Coti!
<br />
<br />
<br />

<p align="center"><a href="https://atomnode.tomoswells.com" target="_blank"><img src="https://camo.githubusercontent.com/a927d600622b8bbc7571407c935c7a62f5838e91829fbee0a7ca2be31ba5cbe7/68747470733a2f2f6d656469612e646973636f72646170702e6e65742f6174746163686d656e74732f3436353638363334383233343335383830342f313038383834333036373432353035303738342f61746f6d732d332d30312e706e673f77696474683d383532266865696768743d383530" style="width: 330px"></a></p>
