A strongly typed martini. Shaken, not stirred. 🍸
===

**Welcome!** This workshop is planned as a beginner-friendly hacking session where we want you to get your hands dirty coding liquid haskell. **Please bring your laptop to the workshop!**

To not waste time on installation problems during the workshop, we kindly ask you to [perform the installation instructions](#installation-instructions) **before the workshop**. Thank you 🤗 !

# Installation instructions
If you **are not** familiar with haskell, the easiest and recommended way to get started is using docker. We have prepared a liquid haskell docker image that comes with batteries included so you don't have to worry about anything! Please proceed to [use docker image](#use-docker-image).

If you **are** familiar with haskell, you can *also* proceed to [install liquid haskell locally](#install-liquid-haskell-locally).

## Use docker image

### 1. Install docker
If you **are not** using docker yet, install docker following the instructions here: https://www.docker.com/get-started.

### 2. Clone the workshop repository
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

You can find more detailed instructions on how to clone or download a repository here: https://help.github.com/articles/cloning-a-repository/.

### 3. Test the docker container

Now that you got docker installed and the repository cloned, you can run the liquid haskell container:

**Mac Os / Linux**
```bash
docker run -ti -v $(PWD):/data janschultecom/docker-liquidhaskell:latest
```
**Windows**
```bash
docker run -ti -v %cd%:/data janschultecom/docker-liquidhaskell:latest
```
This will start to download the liquid haskell docker container and enter the command prompt of the container:
```bash
root@7d8d5dc51645:/data# 
```

**Note**: This may take a few minutes and might look slightly different on your computer.


In the container check the exercise liquid haskell file by running the `liquid` command:
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


## Install liquid haskell locally

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

### Getting started

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

## Use web editor

If you have trouble using the installation methods, you can alternatively use the web editor. Please bear in mind that **the server is a little flaky and might not work reliably during the workshop**.

* [Exercise 1](http://goto.ucsd.edu:8090/index.html#?demo=permalink%2F1540306517_204.hs)
* [Exercise 2](http://goto.ucsd.edu:8090/index.html#?demo=permalink%2F1540306538_207.hs)
* [Exercise 3](http://goto.ucsd.edu:8090/index.html#?demo=permalink%2F1540306560_210.hs)
* [Exercise 4](http://goto.ucsd.edu:8090/index.html#?demo=permalink%2F1540306578_213.hs)
* [Exercise 5](http://goto.ucsd.edu:8090/index.html#?demo=permalink%2F1540306872_220.hs)
* [Exercise 6](http://goto.ucsd.edu:8090/index.html#?demo=permalink%2F1540306624_218.hs)

**Note**: If you see an odd/even example, please refresh your browser.
