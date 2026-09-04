# Neovim

MiniMax-based Neovim 0.12 config. Helix Space mode is primary leader contract.

## Install

Requirements: Neovim 0.12.5+, Git, network access for first plugin clone, and
a C compiler for Tree-sitter parsers.

Clone this directory to `~/.config/nvim`. Start `nvim` once and wait for
`vim.pack` plus Tree-sitter installation to finish. Restart Neovim. Plugin
revisions belong in tracked `nvim-pack-lock.json`.

## Update and rollback

Run `:lua vim.pack.update()` to fetch updates. Review changed
`nvim-pack-lock.json`, then commit it. `:packupdate` is not a Neovim command.

Rollback: restore a known-good `nvim-pack-lock.json`, restart, then run:

```vim
:lua vim.pack.update(nil, { offline = true, target = 'lockfile' })
```

Use `:checkhealth`, `:checkhealth vim.lsp`, and
`:checkhealth vim.treesitter` after installation or an update.

