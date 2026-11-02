#!/usr/bin/env bash
# Usage: ./install.sh [zsh|starship|nvim|git|wezterm ...]   (no args = all)
# 既存ファイルは ~/.dotfiles_backup/<timestamp>/ に退避してから symlink する。
# wezterm は Windows 側の設定なので symlink ではなくコピーする。
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

copy() {
  local src=$1 dst=$2
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    echo "ok    $dst"
    return
  fi
  if [ -e "$dst" ]; then backup "$dst"; fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "copy  $dst"
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
  # WEZTERM_HOME で配置先を上書き可。未指定なら WSL の Windows ユーザーホーム。
  local dest="${WEZTERM_HOME:-}"
  if [ -z "$dest" ]; then
    if ! command -v cmd.exe >/dev/null || ! command -v wslpath >/dev/null; then
      echo "skip  wezterm: WSL ではありません。WEZTERM_HOME=<dir> を指定してください" >&2
      return
    fi
    dest="$(wslpath -u "$(cd /mnt/c && cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
  fi
  copy "$REPO/wezterm/.wezterm.lua" "$dest/.wezterm.lua"
  copy "$REPO/wezterm/.config/wezterm/keybinds.lua" "$dest/.config/wezterm/keybinds.lua"
}

targets=("$@")
[ ${#targets[@]} -gt 0 ] || targets=(zsh starship nvim git wezterm)

for t in "${targets[@]}"; do
  case "$t" in
    zsh|starship|nvim|git|wezterm) "install_$t" ;;
    *) echo "unknown target: $t (zsh|starship|nvim|git|wezterm)" >&2; exit 1 ;;
  esac
done
