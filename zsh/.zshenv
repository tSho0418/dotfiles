# PATH の重複を自動的に排除（zsh の機能）
typeset -U path PATH

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/opt/nvim"
export PATH="$PATH:/mnt/c/Users/tshow/AppData/Local/Programs/Microsoft VS Code/bin"

# --- Java ---
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
