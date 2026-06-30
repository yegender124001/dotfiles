#!/bin/bash

echo "--- Neovim config"
ln -sf $(pwd)/nvim.lua $HOME/.config/nvim/init.lua

echo "--- Sway"
ln -sf $(pwd)/sway $HOME/.config/sway/config

echo "--- Foot"
ln -sf $(pwd)/foot.ini $HOME/.config/foot/foot.ini


