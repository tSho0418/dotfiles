return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" }, -- ターミナル表示用（任意）
  config = true,
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Claude Code トグル" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "選択範囲を送信" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "変更を適用" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "変更を却下" },
    { "<leader>cx", "<cmd>ClaudeCodeClose<cr>", desc = "Claude Code を閉じる" },
  },
}
