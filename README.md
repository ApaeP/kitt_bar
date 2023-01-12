# Setup

## 1 - Fork and clone the repo


## 2 - Setup your batches

Open the repo
create file `kitt_bar/config/batches.json`

Fill it with the batches you want to have access to
```json
{
  "current_batches":[
    {
      "slug":1139,
      "type":"FT",
      "cursus":"Web",
      "city":"Toulouse"
    },
    {
      "slug":1118,
      "type":"FT",
      "cursus":"Data Analytics",
      "city":"Paris"
    }
  ],
  "old_batches":[
    {
      "slug":993,
      "type":"FT",
      "cursus":"Web",
      "city":"Martinique"
    },
    {
      "slug":827,
      "type":"FT",
      "cursus":"Web",
      "city":"Martinique"
    }
  ]
}
```


## 3 - Set up your script bar client

### macOS

Install Bitbar:

```bash
brew install --cask xbar
```

Launch the Xbar app (check start the app at login).

Make the `kitt_bar/copy_to_plugins.sh` file executable with
```bash
chmod -x copy_to_plugins.sh
```

Execute it
```bash
./copy_to_plugins.sh
```

Refresh your Xbar app and tada 🥳

### linux (WIP - 0%)

The equivalent of Bitbar for Linux is [Argos](https://github.com/p-e-w/argos).To install it go to [the GNOME extension page](https://extensions.gnome.org/extension/1176/argos/) and turn on the installation toggle.

`Argos` monitors the `~/.config/argos` folder to look for scripts to execute. Remove the default `argos.sh` script there and link the `kitt_bar.rb` file to this folder:

```bash
rm ~/.config/argos/argos.sh
ln -s ~/code/$GITHUB_USERNAME/kitt_bar/kitt_bar.rb ~/.config/argos/kitt_bar.rb
```

# TODO
### Find a way to decrypt chrome cookie value (MacOS)
- Sqlite3 DB file location: ~/Library/Application\ Support/Google/Chrome/Default/Cookies
- `SELECT value, encrypted_value FROM cookies WHERE name = "_kitt2017_";`
  - value is empty
  - To get Chrome Safe Storage password `security find-generic-password -ga "Chrome"`
  - [some info here](https://stackoverflow.com/questions/57646301/decrypt-chrome-cookies-from-sqlite-db-on-mac-os)
### Add a "last refresh" info line down the menu
### Try to set batches infos as [env variables from xbar config](https://github.com/matryer/xbar-plugins/blob/main/CONTRIBUTING.md#plugin-with-variables)
