# Setup

## Fork and clone this repo

Fork [`ApaeP/kitt_bar`](https://github.com/ApaeP/kitt_bar) to your own GitHub account and clone it on your computer:

```bash
export GITHUB_USERNAME=`gh api user | jq -r '.login'`
cd ~/code/$GITHUB_USERNAME/xbar_plugins
gh repo clone kitt_bar
```
### Configure your script

Open the `~/code/$GITHUB_USERNAME/xbar_plugins/kitt_bar.rb` file

Update line `12` with your batch numbers:
```ruby
BATCH_SLUGS = [1030, 1003]
```
Create a `.env` file inside the cloned repo:
```bash
cd ~/code/$GITHUB_USERNAME/xbar_plugins/kitt_bar
touch .env
```
Open the `.env` file, add a variable `KITT_USER_COOKIE` and store your kitt cookie in it like this:
```bash
KITT_USER_COOKIE="_your_kitt_cookie_here_"
```

## Set up your script bar client

### macOS

Install Bitbar:

```bash
brew install --cask xbar
```

Then launch the Xbar app (and chose to start the app at login).

Locate the xbar plugin folder (it should be in `/Users/your_username/Library/Application Support/xbar/plugins`)

Open the `~/code/$GITHUB_USERNAME/xbar_plugins/kitt_bar/.env` file
Add a variable `PLUGINS_CURRENT_PATH` and store your plugins path in it like this:
```bash
PLUGINS_CURRENT_PATH="/Users/paulportier/Library/Application Support/xbar/plugins"
```

Make the `copy_to_plugins.sh` file executable with
```bash
chmod 755 copy_to_plugins.sh
```

And execute this bash file with
```bash
./copy_to_plugins.sh
```
Finally refresh your Xbar app and tada 🥳

### linux
I HAVE NOT TESTED THIS

The equivalent of Bitbar for Linux is [Argos](https://github.com/p-e-w/argos).To install it go to [the GNOME extension page](https://extensions.gnome.org/extension/1176/argos/) and turn on the installation toggle.

`Argos` monitors the `~/.config/argos` folder to look for scripts to execute. Remove the default `argos.sh` script there and link the `kitt_bar.rb` file to this folder:

```bash
rm ~/.config/argos/argos.sh
ln -s ~/code/$GITHUB_USERNAME/kitt_bar/kitt_bar.rb ~/.config/argos/kitt_bar.rb
```
