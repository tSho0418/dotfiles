return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- ファイルを開いた時に読み込む
  lazy = false,                            -- エラー回避のため、一旦遅延読み込みを無効化して最優先にする
  priority = 1000,                         -- 非常に高い優先度を設定
  opts = {
    ensure_installed = { "python", "typescript", "lua", "vim", "vimdoc", "go" },
    highlight = {
      enable = true,
    },
  },
  config = function(_, opts)
    -- モジュールがあるか慎重に確認してから setup する
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if status then
      configs.setup(opts)
    else
      print("Treesitter configs not found yet - standard loading failed")
    end
  end,
}
