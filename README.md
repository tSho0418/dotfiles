# dotfiles

WSL2 (Ubuntu) + Windows 側 WezTerm 前提の個人設定。

| dir | 配置先 | 方式 |
|---|---|---|
| `zsh/` | `~/.zshenv` `~/.zshrc` `~/.fzf.zsh` | symlink |
| `starship/` | `~/.config/starship.toml` | symlink |
| `nvim/` | `~/.config/nvim` | symlink (lazy.nvim) |
| `git/` | `~/.gitconfig` | symlink |
| `wezterm/` | `%USERPROFILE%\.wezterm.lua`, `%USERPROFILE%\.config\wezterm\keybinds.lua` | **copy** (Windows アプリは WSL の symlink を辿れない) |

## Install

```sh
./install.sh            # 全部
./install.sh nvim zsh   # 一部だけ
WEZTERM_HOME=~ ./install.sh wezterm   # WSL 以外で wezterm を置く場合
```

- 既存ファイルは `~/.dotfiles_backup/<timestamp>/` に退避される。再実行しても冪等。
- `zsh` ターゲットは oh-my-zsh と `zsh-autosuggestions` / `zsh-syntax-highlighting` が無ければ clone する。
- wezterm は copy なので、`wezterm/` を編集したら `./install.sh wezterm` で反映する。

## 前提 (本リポジトリでは管理しない)

- zsh, git, starship, neovim, wezterm
- `.zshrc` が参照: fzf, bat, peco, nvm, go, kubectl, lazygit, docker (無いものは該当部分が効かないだけ。ただし `go` 無しだと起動時に `go env` のエラーが出る)
- フォント: SF Mono, PlemolJP Console NF, Symbols Nerd Font Mono (starship/wezterm のグリフ用)

## 含めていないもの

- `~/.config/gh/hosts.yml` など認証情報を含むもの
- シェル履歴, `.zcompdump*`, `*.old`, `*.save`
- `.zshenv` の `JAVA_HOME` / TeX Live / VS Code の PATH はこのマシン固有の値。別マシンでは調整する。
