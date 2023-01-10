# TODO
### Find a way to decrypt chrome cookie value (MacOS)
- Sqlite3 DB file location: ~/Library/Application\ Support/Google/Chrome/Default/Cookies
- `SELECT value, encrypted_value FROM cookies WHERE name = "_kitt2017_";`
  - value is empty
  - To get Chrome Safe Storage password `security find-generic-password -ga "Chrome"`
  - [some info here](https://stackoverflow.com/questions/57646301/decrypt-chrome-cookies-from-sqlite-db-on-mac-os)
### Add a "last refresh" info line down the menu
### Try to set batches infos as [env variables from xbar config](https://github.com/matryer/xbar-plugins/blob/main/CONTRIBUTING.md#plugin-with-variables)

--------------------------------------------------------------------------------------------------------------------------
# Setup (Deprecated)

## Fork and clone this repo

### Configure your script

Open the `kitt_bar.rb` file

Update with your batch numbers (example):
```ruby
BATCH_INFOS = [
  { slug: 1003, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 1118, type: 'FT', cursus: 'Data Analytics', city: 'Paris'},
  { slug: 1139, type: 'FT', cursus: 'Web', city: 'Toulouse'},
]

OLD_BATCHES = [
  # Martinique
  { slug: 440, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 320, type: 'FT', cursus: 'Web', city: 'Paris'},
]
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

Make the `copy_to_plugins.sh` file executable with
```bash
chmod -x copy_to_plugins.sh
```

And execute this bash file with
```bash
./copy_to_plugins.sh
```
Finally refresh your Xbar app and tada 🥳

### linux (WIP - 0%)

The equivalent of Bitbar for Linux is [Argos](https://github.com/p-e-w/argos).To install it go to [the GNOME extension page](https://extensions.gnome.org/extension/1176/argos/) and turn on the installation toggle.

`Argos` monitors the `~/.config/argos` folder to look for scripts to execute. Remove the default `argos.sh` script there and link the `kitt_bar.rb` file to this folder:

```bash
rm ~/.config/argos/argos.sh
ln -s ~/code/$GITHUB_USERNAME/kitt_bar/kitt_bar.rb ~/.config/argos/kitt_bar.rb
```
