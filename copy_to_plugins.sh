#!/bin/bash

PLUGINS_PATH="$HOME/Library/Application Support/xbar/plugins"
CURRENT_DIR=`pwd`

cp "${CURRENT_DIR}"/kitt_bar.3s.sh "${PLUGINS_PATH}"/kitt_bar.3s.sh
mkdir -p "${PLUGINS_PATH}"/kitt_bar
cp -R "${CURRENT_DIR}"/app "${CURRENT_DIR}"/config "${CURRENT_DIR}"/data "${CURRENT_DIR}"/tmp "${PLUGINS_PATH}"/kitt_bar/
cp "${CURRENT_DIR}"/app.rb "${PLUGINS_PATH}"/kitt_bar/
chmod +x "${CURRENT_DIR}"/config/kitt_request
