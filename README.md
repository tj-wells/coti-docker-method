<h1 align="center">Coti Node Docker Installation Method</h1>

<p align="center">A method to easily install, upgrade and maintain Coti nodes using Docker.</p>
<p align="center">
	<a href="https://github.com/tomjwells/coti-node"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/tomjwells/coti-node"></a>
    <a href="https://twitter.com/intent/tweet?text=I+just+installed+my+%23COTI+node+with+%40tomjwells%27+Docker+installation+method.+It+worked+like+a+charm%21+%F0%9F%94%A5%0D%0A%0D%0Ahttps%3A%2F%2Fgithub.com%2Ftomjwells%2Fcoti-node%0D%0A%0D%0A%24COTI+%24DJED+%24SHEN+"><img src="https://randojs.com/images/tweetShield.svg" alt="Tweet" height="20"/></a>
</p>

<!-- <p align="center"><a href="https://github.com/tomjwells/gif/blob/master/coti-node-demo-clipped_censored_1080p.gif"><img src="https://media.discordapp.net/attachments/995792094088155227/1070494059610767400/header_img_white-01.png?width=1300&height=825" width="100%" /></a></p><br/> -->

This method also provides:

- Automatic A+ rated SSL certificates
- Easy (one-line) upgrades to new Coti node releases
- A simple node monitor that restarts the node if it is not connected to the network

The video below shows an example of the logs produced when launching a Coti node with Docker:

https://user-images.githubusercontent.com/5472339/233216833-a8843218-c180-4d78-91c4-c6f05d7cb8cf.mov

# [Docker Guide](https://docker.guides.coticommunity.com)

In addition to this readme, I have also made a guide that teaches some basic Docker concepts and walks readers through the steps of setting up a Coti node with Docker. The guide can be found [here](https://docker.guides.coticommunity.com).

The Docker guide will likely be very helpful if you are not already very experienced with Docker.

If you are experienced with Docker, the instructions below should be enough to get your node running. If you have any doubts, you can always check the Docker guide, which gives a more detailed description of the setup process.

Good luck!

# Instructions

This method relies on having the programs `docker` and `docker-compose` installed. First, log in as root using `sudo su`. Then, `docker` can be installed with

```
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```

and `docker-compose` can be installed with

```
curl -L https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

You can check if your installations were successful by running

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
- `PKEY` is your private key. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on obtaining your private key.).
- `SEED` is your wallet's seed. (See [here](https://cotidocs.geordier.co.uk/wallet-and-kyc/generating-your-seed) for guidance on generating a seed for your wallet.).
- `EMAIL` is the email address used to register your SSL certificate.

### Optional Variables

Adding a `VERSION` variable to your `.env` file allows you to define which version of the Coti node should be run by Docker. If the `VERSION` is not specified, Docker will automatically use the latest version. The version variable should be set as

```.env
VERSION="X.Y.Z"
```

where X.Y.Z is a valid version number in semver notation. A list of the available versions can be found on [Dockerhub](https://hub.docker.com/r/atomnode/coti-node/tags). If the version is not specified, Docker will automatically use the latest available release.

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

If you have not set the `VERSION` environment variable in your .env file, to update the Coti node version, simply run

```
docker-compose up -d
```

This causes Docker to check for new versions of the Docker image and installs the latest available version.

If the `VERSION` environment variable was specified, you should first edit the version in your `.env` file. After that, running

```
docker-compose up -d
```

will update your node.

A complete list of the available versions can be found at [Dockerhub](https://hub.docker.com/r/atomnode/coti-node/tags).

## Upgrading through a Web Interface

If you don't want the inconvenience of logging into your server to make manual upgrades, a service called Portainer can be used to manage Docker containers from a web interface. If you want to run your node this way, check my [coti-node-portainer](https://github.com/tomjwells/coti-node-portainer) repository.

# ✨ Credits

- This method uses the official code for Coti nodes at https://github.com/coti-io/coti-node.
- Thanks to [GeordieR](https://twitter.com/Geordie_R), whose scripts helped me in developing this installation method using Docker.
- Credits to the Coti community for the vital support and guidance given to testnet and mainnet node operators.

# 🐳 Which Docker image is used?

As there currently is no official Docker image, this method uses a community-built Docker image. I have submitted a [pull request](https://github.com/coti-io/coti-node/pull/54) to the Coti team to include a github action that would build official Docker images of the Coti node.

To ensure that the images are produced in a fully accountable and transparent way, the images are built publicly using Github Actions in <a href="https://github.com/tomjwells/coti-node-images" target="_blank">this repository</a>. You can find the built images on <a href="https://hub.docker.com/r/atomnode/coti-node/tags" target="_blank">Dockerhub</a>.

# 🧑‍🔬 How can I monitor my node?

Using Docker makes it easy to add other applications to your node. <a href="https://github.com/tomjwells/coti-node-monitoring" target="_blank">See my guide</a> for setting up a monitoring dashboard for Coti nodes.

# Stay Coti

Stay Coti. ️‍🔥
<br />
<br />
<br />


If you have questions, feel free to contact me on twitter <a href="https://twitter.com/tomjwells">@tomjwells</a>.
<br />
<br />
<br />

<p align="center"><a href="https://atomnode.tomoswells.com" target="_blank"><img src="https://camo.githubusercontent.com/a927d600622b8bbc7571407c935c7a62f5838e91829fbee0a7ca2be31ba5cbe7/68747470733a2f2f6d656469612e646973636f72646170702e6e65742f6174746163686d656e74732f3436353638363334383233343335383830342f313038383834333036373432353035303738342f61746f6d732d332d30312e706e673f77696474683d383532266865696768743d383530" style="width: 330px"></a></p>
