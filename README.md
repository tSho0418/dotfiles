# dotfiles

WSL2 (Ubuntu) + Windows 側 WezTerm 前提の個人設定。

| dir | 配置先 | 方式 |
|---|---|---|
| `zsh/` | `~/.zshenv` `~/.zshrc` `~/.fzf.zsh` | symlink |
| `starship/` | `~/.config/starship.toml` | symlink |
| `nvim/` | `~/.config/nvim` | symlink (lazy.nvim) |
| `git/` | `~/.gitconfig` | symlink |
| `wezterm/` | Windows ユーザー環境変数 `WEZTERM_CONFIG_FILE` → リポジトリ直参照 | 環境変数 (WSL 以外は `WEZTERM_HOME` へ symlink) |

## Install

```sh
./install.sh            # 全部
./install.sh nvim zsh   # 一部だけ
WEZTERM_HOME=~ ./install.sh wezterm   # WSL 以外で wezterm を置く場合
```

- 既存ファイルは `~/.dotfiles_backup/<timestamp>/` に退避される。再実行しても冪等。
- `zsh` ターゲットは oh-my-zsh と `zsh-autosuggestions` / `zsh-syntax-highlighting` が無ければ clone する。
- wezterm: Windows アプリは WSL 内の symlink を辿れず、Windows 側 symlink は管理者権限が要る。そのため Windows ユーザー環境変数 `WEZTERM_CONFIG_FILE` に `\\wsl.localhost\Ubuntu\...\wezterm\.wezterm.lua` を設定し、リポジトリを直接読ませる。ファイルのコピーは無く、編集は WezTerm の再読込 (`Ctrl+Shift+R`) で反映される。初回設定後は WezTerm を完全終了して起動し直す。
- 旧方式で Windows 側に置いたコピー (`%USERPROFILE%\.wezterm.lua` など) は `~/.dotfiles_backup/` に退避される。
- 制約: WezTerm 起動時に WSL (`\\wsl.localhost`) へアクセスできる必要がある。読めない場合は WezTerm が既定設定で起動する。

## 前提 (本リポジトリでは管理しない)

- zsh, git, starship, neovim, wezterm
- `.zshrc` が参照: fzf, bat, peco, nvm, go, kubectl, lazygit, docker (無いものは該当部分が効かないだけ。ただし `go` 無しだと起動時に `go env` のエラーが出る)
- フォント: SF Mono, PlemolJP Console NF, Symbols Nerd Font Mono (starship/wezterm のグリフ用)

## 含めていないもの

- `~/.config/gh/hosts.yml` など認証情報を含むもの
- シェル履歴, `.zcompdump*`, `*.old`, `*.save`
- `.zshenv` の `JAVA_HOME` / TeX Live / VS Code の PATH はこのマシン固有の値。別マシンでは調整する。
