#!/usr/bin/env bash
# Usage: ./install.sh [zsh|starship|nvim|git|wezterm ...]   (no args = all)
# 既存ファイルは ~/.dotfiles_backup/<timestamp>/ に退避してから symlink する。
# wezterm は Windows ユーザー環境変数 WEZTERM_CONFIG_FILE で WSL 上の設定を直接参照する。
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"

backup() {
  local dst=$1
  mkdir -p "$BACKUP"
  mv "$dst" "$BACKUP/$(printf '%s' "$dst" | tr / _)"
  echo "bak   $dst -> $BACKUP"
}

link() {
  local src=$1 dst=$2
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    echo "ok    $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then backup "$dst"; fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "link  $dst"
}

clone_if_missing() {
  local url=$1 dir=$2
  [ -d "$dir" ] || git clone --depth=1 "$url" "$dir"
}

install_zsh() {
  # .zshrc が前提とする oh-my-zsh と 2 つの外部プラグイン
  local omz="${ZSH:-$HOME/.oh-my-zsh}"
  clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$omz"
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$omz/custom/plugins/zsh-autosuggestions"
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$omz/custom/plugins/zsh-syntax-highlighting"
  local f
  for f in .zshenv .zshrc .fzf.zsh; do link "$REPO/zsh/$f" "$HOME/$f"; done
}

install_starship() { link "$REPO/starship/starship.toml" "$CONFIG/starship.toml"; }
install_nvim()     { link "$REPO/nvim" "$CONFIG/nvim"; }
install_git()      { link "$REPO/git/.gitconfig" "$HOME/.gitconfig"; }

install_wezterm() {
  if [ -n "${WEZTERM_HOME:-}" ]; then
    # WSL 以外: 同じディレクトリに 2 ファイルを symlink (.wezterm.lua が自身の隣の keybinds.lua を読む)
    link "$REPO/wezterm/.wezterm.lua" "$WEZTERM_HOME/.wezterm.lua"
    link "$REPO/wezterm/keybinds.lua" "$WEZTERM_HOME/keybinds.lua"
    return
  fi
  if ! command -v powershell.exe >/dev/null || ! command -v wslpath >/dev/null; then
    echo "skip  wezterm: WSL ではありません。WEZTERM_HOME=<dir> を指定してください" >&2
    return
  fi
  # Windows アプリは WSL 内の symlink を辿れず、Windows 側 symlink は管理者権限が要る。
  # そこで WezTerm の WEZTERM_CONFIG_FILE (ユーザー環境変数) で WSL 上の設定を直接指す。
  local want cur
  want="$(wslpath -w "$REPO/wezterm/.wezterm.lua")"
  cur="$(powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('WEZTERM_CONFIG_FILE','User')" | tr -d '\r')"
  if [ "$cur" = "$want" ]; then
    echo "ok    WEZTERM_CONFIG_FILE=$want"
  else
    powershell.exe -NoProfile -Command "[Environment]::SetEnvironmentVariable('WEZTERM_CONFIG_FILE','$want','User')"
    echo "set   WEZTERM_CONFIG_FILE=$want (WezTerm を完全に終了して起動し直すと反映)"
  fi
  # 環境変数が優先されるので、旧 copy 方式のファイルは紛らわしいため退避する
  local win f
  win="$(wslpath -u "$(cd /mnt/c && cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
  for f in "$win/.wezterm.lua" "$win/.config/wezterm/keybinds.lua"; do
    if [ -e "$f" ]; then backup "$f"; fi
  done
}

targets=("$@")
[ ${#targets[@]} -gt 0 ] || targets=(zsh starship nvim git wezterm)

for t in "${targets[@]}"; do
  case "$t" in
    zsh|starship|nvim|git|wezterm) "install_$t" ;;
    *) echo "unknown target: $t (zsh|starship|nvim|git|wezterm)" >&2; exit 1 ;;
  esac
done
