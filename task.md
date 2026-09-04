# Neovim meets Helix

I want you to layout my neovim configuration, with the goal to mimic some important aspects of helix.
We do not want to mimic the inverted grammar, nor do we want to align normal mode keybindings to helix in general.
Instead we're aiming to use neovim with its bindings but enhance the experience to get closer to what I have in my helix config.

The most important aspects to replicate:

* the m keybindings. Helix exposes a set of functions under the m prefix in normal mode. I want to have the same way to access the nvim equivalents
* multiple cursors. I want a well working way to deal with multiple cursors
* leader menu. I want to follow the leader key that I currently have configured also for my helix. We will find suitable alternatives for a couple of things that don't exist in nvim.

How to build the neovim config.

1. Use the latest neovim
2. Base the configuration on minimax https://github.com/nvim-mini/MiniMax. This already brings some of the required keybindings for the m-modes via mini.ai
3. Theme modus-vivendi
4. Oil.nvim to deal with files
5. Top notch LSP integration with the new nvim native way to configure an activate.
   Support for:
   - ruby
   - scala
   - golang
   - gotmpl
   - helm
   - yaml
   - json
6. All configuration LUA.


How to approach it.
Analyze and research latest documentation, then layout the plan and the issues that follow from it.
Create issues as markdown files for each of the things to be done in the issues/ directory.
