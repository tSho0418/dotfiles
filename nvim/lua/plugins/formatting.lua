return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- 保存時に自動実行するためにイベントを設定
  cmd = { "ConformInfo" },
  keys = {
    {
      -- 手動整形のキーマップ (Leader + f)
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    -- 言語ごとのフォーマッタ指定
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      -- 複数のフォーマッタを順に試すことも可能
      -- python = { "isort", "black" },
    },
    -- 保存時の自動整形設定
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
