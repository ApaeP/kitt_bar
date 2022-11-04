#!/bin/bash

source .env

PLUGINS_PATH="$PLUGINS_CURRENT_PATH"
CURRENT_DIR=`pwd`

cp "${CURRENT_DIR}"/kitt_bar.3s.rb "${PLUGINS_PATH}"/kitt_bar.3s.rb
cp "${CURRENT_DIR}"/.env "${PLUGINS_PATH}"/.env
cp -R "${CURRENT_DIR}"/kitt_bar_app "${PLUGINS_PATH}"
