return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- 1. mason 本体を初期化
    require("mason").setup()

    -- 2. mason-lspconfig の setup 内にすべて記述する
    require("mason-lspconfig").setup({
      -- インストールしたいLSPサーバー
      ensure_installed = {
        "lua_ls",
        "ts_ls", -- 旧 tsserver
        "pyright",
      },

      -- ここに setup_handlers の内容を直接書く（これが確実です）
      handlers = {
        -- デフォルトのセットアップ挙動

        function(server_name)
          -- local capabilities = require("cmp_nvim_lsp".default_capabilities()
          require("lspconfig")[server_name].setup({})
        end,

        -- 特定のサーバーに個別設定が必要な場合のみ、以下のように記述
        -- ["lua_ls"] = function()
        --   require("lspconfig").lua_ls.setup({
        --     settings = { Lua = { diagnostics = { globals = { "vim" } } } }
        --   })
        -- end,
      },
    })
  end,
}
