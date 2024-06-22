# Setup

## MacOS

>This only works on MacOS.
>You are welcome to contribute to make it work on Linux and/or Windows
>see NOTES.md

### 1 - Install

Install xbar

```bash
brew install --cask xbar
```

Clone and install the plugin

```bash
export GITHUB_USERNAME=`gh api user | jq -r '.login'`
cd ~/code/$GITHUB_USERNAME
mkdir xbar && cd $_
git clone git@github.com:ApaeP/kitt_bar.git
cd kitt_bar
chmod -x copy_to_plugins.sh
mv config/settings.example.json config/settings.json
echo "alias kitt_bar_setup=\"code ~/code/$GITHUB_USERNAME/xbar/kitt_bar/kitt_bar_app/config/settings.json\"" >> ~/code/$GITHUB_USERNAME/dotfiles/aliases
echo "alias kitt_bar_update=\"sh ~/code/$GITHUB_USERNAME/xbar/kitt_bar/copy_to_plugins.sh\"" >> ~/code/$GITHUB_USERNAME/dotfiles/zshrc
exec zsh
```

### 2 - Setup

Open the settings file
```bash
kitt_bar_setup
```

Fill in your batches and skills
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
      "slug":320,
      "type":"FT",
      "cursus":"Web",
      "city":"Paris"
    }
  ],
  "skills": [
    {
      "rails/project": [
        {
          "skill_id": 4,
          "can_do": true
        }
      ],
      "js": [
        {
          "skill_id": 7,
          "can_do": true
        }
      ],
      "html/css": [
        {
          "skill_id": 5,
          "can_do": true
        }
      ]
    }
  ]
}
```

Save and close the file, then register it in your plugin
```bash
kitt_bar_update
```

### 3 - Login
As this script needs to authenticate you on Kitt in order to retrieve your current tickets, it needs to access your Kitt session cookie.
To do so, all you have to do is to login on Kitt with `Mozilla Firefox`.
The script will then be able to retrieve your session cookie and store it in the `config/settings.json` file.

>We're trying to make it work with Chrome,
>but chrome encrypts its cookies database and we haven't yet succeded in decrypting it,
>Brave/Safari/Opera are not supported yet.
>You are welcome to contribute to this feature.

### 4 - Enjoy

Run xbar and enjoy your new plugin

