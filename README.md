# dotfiles

## basic information
### software
These are config files for my setup. Currently, the software in use:
- [foot](https://codeberg.org/dnkl/foot) - terminal
- [yambar](https://codeberg.org/dnkl/yambar) - status panel
- [fuzzel](https://codeberg.org/dnkl/fuzzel) - launcher
- [neovim](https://github.com/neovim/neovim) - text editor
- [river](https://github.com/riverwm/river) - window manager

### update script
Included is a simple script that compares the files in `XDG_CONFIG_HOME` to the repository. It will either copy them over, show a diff, or do nothing at the user's preference.

```
# Check for updated files and prompt user per file 
./update-conf.sh

# Add all updated files without prompt
./update-conf.sh -A

# Check for untracked files and prompt
./update-conf.sh -a

# Show modified and untracked files
./update-conf.sh -s
```
