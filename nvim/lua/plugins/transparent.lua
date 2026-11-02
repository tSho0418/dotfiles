return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- 起動時に適用
  config = function()
    require("transparent").setup({
      -- 透明にしたいグループを指定
      extra_groups = {
        "NormalFloat", -- 浮遊ウィンドウ
        "NvimTreeNormal", -- nvim-treeを使う場合
        "NeoTreeNormal", -- neo-treeを使う場合
      },
    })
  end,
}
