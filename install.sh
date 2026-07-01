#!/bin/bash

echo "--- Neovim config"
mkdir -p $HOME/.config/nvim
ln -sf $(pwd)/nvim.lua $HOME/.config/nvim/init.lua

echo "--- Sway"
mkdir -p $HOME/.config/sway
ln -sf $(pwd)/sway $HOME/.config/sway/config

echo "--- Foot"
mkdir -p $HOME/.config/foot
ln -sf $(pwd)/foot.ini $HOME/.config/foot/foot.ini

echo "--- Mako"
mkdir -p $HOME/.config/mako
ln -sf $(pwd)/mako $HOME/.config/mako/config
