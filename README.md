A strongly typed martini. Shaken, not stirred. 🍸
===

**Welcome!** This workshop is planned as a beginner-friendly hacking session where we want you to get your hands dirty coding liquid haskell. **Please bring your laptop to the workshop!**

To not waste time on installation problems, we kindly ask you to [**follow the installation instructions.**](#installation-instructions)

# Installation instructions
If you **are not** familiar with haskell, the easiest and recommended way to get started is using docker. We have prepared a liquid haskell docker image that comes with batteries included so you don't have to worry about installing anything! Please proceed to [install docker](#1.-install-docker).

If you **are** familiar with haskell, you can proceed to the [alternative installation section](#alternative-installation) to install liquid haskell locally.


## 1. Install docker
Follow the instructions here: https://www.docker.com/get-started

## 2. Clone the workshop repository
If you **are** familiar with git you can just clone the repository:

```bash
git clone https://github.com/janschultecom/20181025-strongly-typed-martini.git
cd 20181025-strongly-typed-martini
```

If you **are not** familiar with git you can also download the repository as a zip file:

    1. click on 'Clone or download' 
    2. click on 'Download ZIP' 
    3. unzip the file 
    4. open command prompt and change to the directory

You can find more detailed instructions on how to clone or download a repository on [github](https://help.github.com/articles/cloning-a-repository/).

## 3. Test the docker container

Now that you got docker installed and the repository cloned, you can run the liquid haskell container:

**Mac Os / Linux**
```bash
docker run -ti -v $(PWD):/data janschultecom/docker-liquidhaskell:latest
```
**Windows**
```bash
docker run -ti -v %cd%:/data janschultecom/docker-liquidhaskell:latest
```
This will enter the container and you should see a command prompt (it might look slightly different):
```bash
root@7d8d5dc51645:/data# 
```

In the container check the exercise liquid haskell file by running the 'liquid' command:
```bash
root@7d8d5dc51645:/data# liquid --full src/haskell/Exercise1.hs
```

You should get the following output:
```
**** DONE:  A-Normalization ****************************************************


**** DONE:  Extracted Core using GHC *******************************************


**** DONE:  Transformed Core ***************************************************

Working 150% [==================================================================================================]

**** DONE:  annotate ***********************************************************


**** RESULT: SAFE **************************************************************
```

**If you see this, you are good to go 🙌 !** You don't have to do anything else! See you at the workshop!


# Alternative installation

## Install Liquid Haskell

Requirements:

1. SMTLIB2 compatible solver installed and its executable found on PATH (in our case [Z3](https://github.com/Z3Prover/z3))

* Linux: `sudo apt-get install z3`
* Mac OS: `brew install z3`

2. [Stack](https://docs.haskellstack.org/en/stable/README/)

```
$ wget -qO- https://get.haskellstack.org/ | sh
```

In order to have `stack` installed executable availables we need to modify the `$PATH`. To do that, please add the following line to your `~/.bashrc` or `~/.zshrc`

```
export PATH=$HOME/.local/bin:$PATH
```

And now we proceed to install [Liquid Haskell](https://github.com/ucsd-progsys/liquidhaskell/blob/develop/INSTALL.md)

```
$ git clone --recursive https://github.com/ucsd-progsys/liquidhaskell.git ~/liquidhaskell
$ cd ~/liquidhaskell
$ stack install 
```

## Getting started

(Please be sure you went through the upper section)

To get started with this repository you can easily do:

```
$ stack install
```

So you can get the proper GHC version and dependencies installed.

Check the exercise liquid haskell file by running the 'liquid' command:
```bash
liquid --full src/haskell/Exercise1.hs
```