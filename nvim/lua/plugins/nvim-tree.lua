-- open File Tree when open
local function open_nvim_tree()
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする" },
    { mode = "n", "<C-e>", "<cmd>NvimTreeFocus<CR>", desc = "ツリーへフォーカス" },
    { mode = "n", "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", desc = "現在のファイルをツリーで表示" },
  },
  config = function()
    local api = require("nvim-tree.api")
    local function my_on_attach(bufnr)
      -- 既定キーマップを維持
      api.config.mappings.default_on_attach(bufnr)

      -- ツリー側: <C-e> でエディタへ戻る（既定の "Open: In Place" を上書き）
      vim.keymap.set("n", "<C-e>", "<cmd>wincmd p<CR>", {
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
        desc = "エディタへ戻る",
      })
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach,
      git = {
        enable = true,
        ignore = true,
      },
      actions = {
        change_dir = {
          restrict_above_cwd = true, -- 起動ディレクトリより上へルートを変えさせない
        },
        open_file = {
          quit_on_open = false, -- ファイルを開いてもツリーは閉じない
        },
      },
      update_focused_file = {
        enable = true,       -- 今開いているファイルをツリー上でハイライト
        update_root = false, -- ルートは変えない（固定ルートを維持）
      },
      view = {
        width = 35,
      },
      renderer = {
        group_empty = true,                 -- 空の連続ディレクトリをまとめて表示
        indent_markers = { enable = true }, -- インデント線を表示
        root_folder_label = ":t",           -- ルート表示をフォルダ名だけに
      },
    })
  end,
}
