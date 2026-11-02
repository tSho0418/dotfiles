vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")


vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("i", "kk", "<esc>")
vim.keymap.set("n", "<C-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>bdelete<CR>")

vim.keymap.set("n", "<leader>o", "o<Esc>", { desc = "下に空行を追加" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { desc = "上に空行を追加" })

vim.keymap.set({ "n", "x" }, "c", '"_c', { desc = "ヤンクせずにチェンジ" })
vim.keymap.set({ "n", "x" }, "C", '"_C', { desc = "ヤンクせずにチェンジ" })
vim.keymap.set("x", "p", '"_dP', { desc = "貼り付け元を保持してペースト" })


-- エラー詳細をポップアップ表示 (gl: get line diagnostic)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show error detail" })

-- 前後のエラーにジャンプ
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "前の診断" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "次の診断" })

-- gl: 診断ポップアップ表示 → 再押下でポップアップ内へ → q/<Esc> で閉じる
local diag_win = nil
vim.keymap.set("n", "gl", function()
  if diag_win and vim.api.nvim_win_is_valid(diag_win) then
    vim.api.nvim_set_current_win(diag_win) -- 2回目: 中に入る
    return
  end
  local _, win = vim.diagnostic.open_float(nil, {
    focusable = true,
    border = "rounded",
    scope = "line",
  })
  diag_win = win
  if win then
    local buf = vim.api.nvim_win_get_buf(win)
    for _, key in ipairs({ "q", "<Esc>" }) do
      vim.keymap.set("n", key, function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        diag_win = nil
      end, { buffer = buf, nowait = true, silent = true })
    end
  end
end, { desc = "診断表示 / 再押下でフォーカス" })

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- cursor
-- vim.opt.guicursor = "n-i:ver25"

-- ヤンクした内容をシステムクリップボード（OS側）にも反映させる
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true -- 背景を透明にする関数
local function transparent_background()
  local groups = {
    "Normal", "NormalNC", "LineNr", "Folded", "NonText",
    "SpecialKey", "VertSplit", "SignColumn", "EndOfBuffer"
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- ビジュアルモードでインデント後も選択を維持
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- ビジュアルモードで選択行を上下に移動
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- カラースキーマ適用時や起動時に実行
transparent_background()

-- カラースキーマを変更した時も透明度を維持する場合
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = transparent_background,
})
