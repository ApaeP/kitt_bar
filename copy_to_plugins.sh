#!/bin/bash

PLUGINS_PATH="$HOME/Library/Application Support/xbar/plugins"
CURRENT_DIR=`pwd`

cp "${CURRENT_DIR}"/kitt_bar.3s.rb "${PLUGINS_PATH}"/kitt_bar.3s.rb
cp -R "${CURRENT_DIR}"/kitt_bar_app "${PLUGINS_PATH}"
chmod +x "${CURRENT_DIR}"/kitt_bar_app/config/kitt_request
