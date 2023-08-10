echo "set -o vi" >> ~/.bashrc

echo "# custom terminal profiles" >> ~/.basrc
echo "alias ssh="gnome-terminal --window-with-profile=SSH -- 'ssh'"" >> ~.basrc


echo "export WEZTERM_CONFIG_FILE=$HOME/.config/nvim/wezterm.lua" >> ~/.basrc
