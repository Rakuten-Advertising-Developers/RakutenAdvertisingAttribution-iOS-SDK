### Ruby installation guide

##### 1. Using ZSH in your Terminal
MacOS Catalina has changed the default terminal from Bash to ZSH. As a result, we'll be adding configs to `~/.zshrc` instead of `~/.bash_profile` like we used in the past.
You can manually change from Bash to ZSH anytime by running the following command:
```sh
chsh -s /bin/zsh
```
##### 2. Install [Homebrew](https://brew.sh/)
First, we need to install Homebrew. Homebrew allows us to install and compile software packages easily from source. Homebrew comes with a very simple install script. When it asks you to install XCode CommandLine Tools, say yes.
Open Terminal and run the following command:
```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
##### 3. Install Ruby
Now that we have Homebrew installed, we can use it to install Ruby. We're going to use rbenv to install and manage our Ruby versions. To do this, run the following commands in your Terminal:
```sh
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
source ~/.zshrc

# Install Ruby
rbenv install 2.7.0
rbenv global 2.7.0
ruby -v
```
