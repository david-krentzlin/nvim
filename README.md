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

<<<<<<< HEAD
=======
## Daily keys

Space keys follow Helix where Neovim has an equivalent:

| Key | Action |
| --- | --- |
| `<Space>f` / `<Space>F` | Files at root / current directory |
| `<Space>e` / `<Space>.` / `-` | Oil root / file directory / parent directory |
| `<Space>b` / `<Space>j` / `<Space>g` | Buffers / jumplist / changed files |
| `<Space>s` / `<Space>o` | Toggle Aerial outline |
| `<Space>d` / `<Space>D` | Document / workspace diagnostics |
| `<Space>a` / `<Space>r` / `<Space>h` / `<Space>k` | Code action / rename / references / hover |
| `<Space>S` | Workspace symbols |
| `<Space>c` / `<Space>C` | Toggle current line or selected lines comments |
| `<Space>p` / `<Space>P` / `<Space>y` / `<Space>Y` / `<Space>R` | Clipboard paste, yank, replace |
| `<Space>/` / `<Space>?` / `<Space>*` | Workspace grep / commands / grep word |
| `<Space>w` | Native window prefix |

Match prefix: `mm` matching bracket; `ms`, `mr`, `md` are Mini.surround;
`mig` selects current Git-index hunk; `mg` shows hunk overlay, then visual
`mg` shows selected hunk history. Use Mini.ai with Neovim's native grammar:
`diF` deletes inside a function definition, `caC` changes around a class, and
`vib` selects inside the current bracket pair. After `a` or `i`, mini.clue
lists available textobjects in operator-pending and Visual modes.

Multiple cursors use `<Space>m`, never arrow keys:

| Key | Action |
| --- | --- |
| `<Space>mj` / `<Space>mk` | Add cursor below / above |
| `<Space>mn` / `<Space>mN` | Add next / previous match |
| `<Space>ms` / `<Space>mS` | Skip next / previous match |
| `<Space>mh` / `<Space>ml` | Previous / next primary cursor |
| `<Space>md` / `<Space>mq` / `<Space>mc` | Delete primary / toggle sync / clear |
| `Esc` | Clear active cursors |

Oil: edit entries, then `:write` to apply. `^` moves to parent; `q` closes.

## Language servers

Install server executables independently. Project-local executable wins when
server supports it.

| Language | Required executable | Notes |
| --- | --- | --- |
| Ruby | `ruby-lsp` | `ruby-lsp --version` must succeed from project bundle or PATH; `rubyfmt` and `standardrb` only when project supplies them. |
| Scala | `metals`, Java | Open sbt, Mill, or Scala CLI workspace. |
| Go and standalone `*.gotmpl` | `gopls` | Go templates use `gotmpl` filetype. |
| Helm charts | `helm_ls` | Chart templates get `helm` filetype, rooted at `Chart.yaml`. |
| YAML | `yaml-language-server` | Plain YAML only; Helm does not attach `yamlls`. |
| JSON | `vscode-json-language-server` | From `vscode-langservers-extracted`. |
| Markdown | `zk`, `simple-completion-language-server` | `zk` needs `.zk` root. |
| Org | `simple-completion-language-server` | |
| Rust | `rust-analyzer` | |
| Bash | `bash-language-server` | |
| HTML | `vscode-html-language-server` | |
| Elixir | `expert` | Install with `mise use expert` or `brew install expert`. |

Helm templates work in arbitrary names below a chart's `templates/` directory,
including `*.gotmpl`; presence of an ancestor `Chart.yaml` decides Helm mode.
Outside a chart, `*.gotmpl` uses `gopls`.

## Troubleshooting

- First start needs network access. Failed clone: restore connectivity, delete
  only affected package, restart.
- Missing LSP: run `:checkhealth vim.lsp`, then confirm executable with
  `:echo executable('gopls')` (replace name).
- Ruby shim error: configure a Ruby and `ruby-lsp` version in mise, or use the
  project's Bundler executable. `ruby-lsp --version` must print a version.
- Missing Expert: install it with `mise use expert` or `brew install expert`,
  then restart Neovim.
- Wrong Helm behavior: confirm file is below a directory with ancestor
  `Chart.yaml`; inspect `:set filetype?`.
- Tree-sitter error: run `:checkhealth vim.treesitter nvim-treesitter`, then
  `:TSInstall <language>` after compiler setup.
- Oil change not applied: use `:write`; changes intentionally require save and
  confirmation.
- LSP maps appear only after a client attaches. Use `:LspInfo` and `:LspRestart`.

## Verification

Fixture projects live in `tests/fixtures`. Run deterministic config checks:

```sh
for spec in tests/*_spec.lua; do
  XDG_STATE_HOME="$(mktemp -d)" XDG_CACHE_HOME="$(mktemp -d)" \
    nvim --headless tests/fixtures/go/main.go \
    "+lua dofile(vim.fn.getcwd() .. '/' .. '${spec}')" +qa
done
```

This verifies config policy, mappings, filetype routing, whitespace behavior,
and Aerial config. It does not prove every external server attaches: that needs
installed executables plus a real project runtime. Open each fixture, run
`:LspInfo`, then exercise `gd`, `<Space>a`, `<Space>r`, formatting, and
`:LspRestart` manually.

Current verification: Go, standalone Go templates, Helm, YAML, and JSON attach
in the included fixtures. Ruby needs a working `ruby-lsp` runtime. Scala needs
a real sbt, Mill, or Scala CLI workspace and Java, so fixture attachment is not
run automatically. A clean plugin install needs GitHub access; offline clean
install cannot pass until plugins and parsers are available locally.
>>>>>>> e0fb2db (tweak)
