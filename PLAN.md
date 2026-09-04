# Neovim meets Helix plan

## Goal

Build a Lua-only Neovim config from MiniMax for current Neovim. Keep Vim grammar and normal-mode bindings. Add only Helix capabilities user values: match-prefix access, multiple cursors, and the Space leader menu.

## Baseline

- Neovim: 0.12.5 stable. Local `nvim --version` reports 0.12.5; current Homebrew formula uses 0.12.5.
- Starter: MiniMax `nvim-0.12` reference config. It uses native `vim.pack`, Lua, `mini.clue`, `mini.ai`, and `after/lsp/` overrides.
- MiniMap: remove from MiniMax target; no replacement needed.
- Theme: `miikanissi/modus-themes.nvim`, fixed to `modus_vivendi`, then adjusted for parity with local `modus_vivendi_black`.
- File browser: `stevearc/oil.nvim`, with `mini.icons` already supplied by MiniMax.
- LSP: native `vim.lsp.config()` plus `vim.lsp.enable()`. Use `nvim-lspconfig` only as server-config data. Do not call deprecated `require('lspconfig').setup()`.

## Audited configuration facts

### Daily Helix config

- Leader is Space. Custom `<Space>*` selects word under cursor, then runs workspace search.
- UI: true color, relative numbers, block/beam/underline cursors, all popup borders, system clipboard, and a black Modus Vivendi variant.
- Editing: trim trailing whitespace, no automatic completion, no automatic signature help, and no inline diagnostics.
- LSP: `zk` and `scls` for Markdown; `scls` for Org; `gopls`, `golangci-lint-lsp`, `metals`, `ruby-lsp`, `solargraph`, `rust-analyzer`, and `bash-language-server`.
- Filetypes: Helm-like YAML/JSON/HTML Go templates have dedicated glob rules.
- Steel extensions provide recent files, embedded terminal, and file watching.

### Dated Neovim backup

- Already confirms preference for MiniMax, Oil, `multicursor.nvim`, `mini.clue`, `mini.ai`, `mini.pick`, `mini.surround`, and `mini.visits`.
- Oil used `<Space>ee`, `^` for parent, `q` for close, and visible dotfiles. Daily Helix is newer evidence, so target hides dotfiles by default and provides a toggle.
- Existing Go settings enable staticcheck, gofumpt, analyses, code lenses, semantic tokens, template extensions, and inlay hints.
- Existing JSON/YAML settings use SchemaStore. Existing Ruby setup prefers `rubyfmt` and `standardrb`.
- Backup has large grouped leader map for tests, notes, tasks, debugging, and AI. Do not preserve its shape or reserve its keys.
- Existing multicursor mappings use Meta keys and `g` prefixes. Replace them with the requested one-group Leader contract.
- Do not add an embedded terminal or Neogit. Terminal work stays outside Neovim; Git starts with MiniMax `mini.git` only.
- Retain Aerial as the code-outline workflow from dated Neovim config.
- Do not add in-editor AI features. Herdr is the current agent workflow.

## Keymap contract

Use current Helix Space mode as leader contract. Do not inherit MiniMax or backup nested leader groups unless Helix has no suitable equivalent. `mini.clue` documents direct Space mappings.

| Helix intent | Neovim binding | Implementation |
| --- | --- | --- |
| Match bracket | `mm` | Native `%` |
| Add surround | `ms` | `mini.surround` add mapping |
| Replace surround | `mr` | `mini.surround` replace mapping |
| Delete surround | `md` | `mini.surround` delete mapping |
| Around textobject | `ma<object>` | Enter Visual then `a<object>` via `mini.ai` |
| Inside textobject | `mi<object>` | Enter Visual then `i<object>` via `mini.ai` |
| Inner change | `mig` | Select current Git-index hunk with `mini.diff` |
| Existing Vim grammar | `d`, `c`, `y`, `v` plus `a` or `i` | Unchanged |
| Workspace search of word | `<Space>*` | MiniMax picker or `rg` integration |

### Space mode

| Helix binding | Neovim action |
| --- | --- |
| `<Space>f` / `<Space>F` | Files at project root / current directory |
| `<Space>e` / `<Space>.` | Oil at project root / current file directory |
| `<Space>b` / `<Space>j` | Buffer picker / jumplist picker |
| `<Space>g` | Changed-files picker |
| `<Space>k` | LSP hover |
| `<Space>s` / `<Space>S` | Document / workspace symbols |
| `<Space>d` / `<Space>D` | Document / workspace diagnostics |
| `<Space>r` / `<Space>a` / `<Space>h` | Rename / code action / references |
| `<Space>w` | Window actions |
| `<Space>c` / `<Space>C` | Line / block comment |
| `<Space>p` / `<Space>P` / `<Space>y` / `<Space>Y` / `<Space>R` | System clipboard actions |
| `<Space>/` / `<Space>?` | Workspace grep / command picker |
| `<Space>*` | Select word then workspace grep |

Extensions with no direct Helix Space binding: `<Space>m` for cursors and `<Space>o` for Aerial.

### Multicursor contract

Use `<Space>m` as the common multicursor group. MiniMap is removed, so this prefix is available.

| Binding | Action |
| --- | --- |
| `<Space>mj` | Add cursor below |
| `<Space>mk` | Add cursor above |
| `<Space>mn` / `<Space>mN` | Add next / previous text match |
| `<Space>ms` / `<Space>mS` | Skip next / previous text match |
| `<Space>mh` / `<Space>ml` | Select previous / next primary cursor |
| `<Space>md` | Delete primary cursor |
| `<Space>mq` | Toggle cursor synchronization |
| `<Space>mc` | Clear all cursors |

`Esc` remains an immediate cancel and clear key. Arrow keys and the plugin's default Leader mappings are removed.

`ma` and `mi` are selection shortcuts only. They do not change Vim operator grammar. `mini.ai` keeps its normal `a` and `i` textobjects available. `mig` is a Git change/hunk textobject, not a syntax textobject: it uses `mini.diff` against Git index.

## Delivery order

1. Bootstrap unmodified MiniMax `nvim-0.12` configuration and lock plugin revisions.
2. Remove MiniMap, then apply daily-driver editor defaults, colorscheme, and file explorer.
3. Add match-prefix mappings and leader clues.
4. Add `multicursor.nvim`; validate ordinary editing and completion before customizing keys.
5. Configure filetypes, native LSP activation, LSP keymaps, diagnostics, formatting, and server prerequisites.
6. Run clean-start, health, filetype, LSP, Oil, and multicursor checks.
7. Decide which dated Neovim workflows outside original scope should return.

## LSP design

| Need | Filetype | Server/config | Notes |
| --- | --- | --- | --- |
| Ruby | `ruby`, `eruby` | `ruby_lsp` | Primary server. Avoid duplicate diagnostics from Solargraph unless user needs it for a project. |
| Scala | `scala`, `sbt` | `metals` plus `nvim-metals` | Metals-specific plugin is needed for full command and BSP support; do not enable a second Metals client through nvim-lspconfig. |
| Go | `go`, `gomod`, `gowork`, `gotmpl` | `gopls` | Current upstream `gopls` config already includes `gotmpl`. |
| Helm templates | `helm` | custom `helm_ls` | Detect chart templates as `helm`, never plain YAML. Start `helm_ls serve` at `Chart.yaml`. |
| Helm values and YAML | `yaml` | `yamlls` | Keep distinct from Helm buffers. helm-ls can delegate YAML language support for chart files. |
| JSON | `json`, `jsonc` | `jsonls` | Add JSON schema settings and formatter policy. |

Formatter ownership must be one server/tool per filetype. Prefer `ruby_lsp`, `gopls`, `metals`, `yamlls`, and `jsonls` only where each has an approved formatter. Keep `golangci-lint-lsp` and Solargraph out until a project demonstrates a missing capability.

## Open decisions

- Use built-in `vim.pack` despite its experimental label, matching MiniMax 0.12, or substitute another manager.
- Decide exact source of `<Space>*` search results after inspecting MiniMax picker behavior.

## Sources

- [MiniMax nvim-0.12 reference config](https://nvim-mini.org/MiniMax/configs/nvim-0.12/)
- [MiniMax config layout](https://nvim-mini.org/MiniMax/configs/)
- [Neovim 0.12 package manager](https://neovim.io/doc/user/pack/)
- [Native LSP configuration](https://neovim.io/doc/user/lsp/)
- [nvim-lspconfig native migration](https://github.com/neovim/nvim-lspconfig)
- [Helix keymap](https://docs.helix-editor.com/master/keymap.html)
- [Modus Themes for Neovim](https://github.com/miikanissi/modus-themes.nvim)
- [Oil README](https://github.com/stevearc/oil.nvim)
- [multicursor.nvim README](https://github.com/jake-stewart/multicursor.nvim)
- [helm-ls README](https://github.com/mrjosh/helm-ls)
