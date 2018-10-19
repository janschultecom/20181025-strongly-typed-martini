A strongly typed martini. Shaken, not stirred. 🍸
===

Welcome to our workshop about liquid haskell. Our workshop is planned as a *beginner-friendly* hacking session where we want you to get your hands dirty coding liquid haskell. So 1st requirement: **please bring your laptop.**

To not waste time on installation problems, we kindly ask you to **prepare for the workshop by following the installation instructions.**

# Installation instructions
The easiest way to get started is using docker. If you don't know about docker, you can think of it as a lightweight virtual machine. We have prepared a liquid haskell docker image that comes with everything preinstalled! 

# Docker

```
# Clone this repo
git clone https://github.com/janschultecom/20181025-strongly-typed-martini.git
cd 20181025-strongly-typed-martini

# Run the liquid haskell container and mount the directory
docker run -ti -v $(PWD):/data janschultecom/docker-liquidhaskell:latest

# In the container check the exercise liquid haskell file by running the 'liquid' command:
root@7d8d5dc51645:/data# liquid --full src/haskell/Exercise1.hs
```
You should now get the following output:
```
**** DONE:  A-Normalization ****************************************************


**** DONE:  Extracted Core using GHC *******************************************


**** DONE:  Transformed Core ***************************************************

Working 150% [==================================================================================================]

**** DONE:  annotate ***********************************************************


**** RESULT: SAFE **************************************************************
```

**If you see this, you are good to go 🙌! You don't have to do anything more! See you at the workshop! **


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

# Getting started

(Please be sure you went through the upper section)

To get started with this repository you can easily do:

```
$ stack install
```

So you can get the proper GHC version and dependencies installed.
