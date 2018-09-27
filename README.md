A strongly typed martini. Shaken, not stirred. 🍸
===

# Docker

```
# Clone this repo
git clone https://github.com/janschultecom/20181025-strongly-typed-martini.git
cd 20181025-strongly-typed-martini

# Run the liquid haskell container and mount the directory
docker run -ti -v $(PWD):/data janschultecom/docker-liquidhaskell:latest

# In the container check your liquid haskell file
root@7d8d5dc51645:/data# liquid --full src/haskell/Main.hs
```

# Install Liquid Haskell

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
