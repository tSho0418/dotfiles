return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup({
      defaults = {
        cache_picker = {
          num_pickers = 10, -- 閉じても直近10件のピッカー(検索結果)を保持
        },
      },
    })

    local builtin = require('telescope.builtin')
    local action_state = require('telescope.actions.state')

    local last_query = {}

    local function remembered(name)
      return function()
        builtin[name]({
          default_text = last_query[name], -- 前回の入力で開く
          attach_mappings = function(prompt_bufnr, _)
            -- 入力するたびに最新のプロンプトを保存
            vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
              buffer = prompt_bufnr,
              callback = function()
                last_query[name] = action_state.get_current_line()
              end,
            })
            return true -- 既定のキーマップは維持
          end,
        })
      end
    end

    vim.keymap.set('n', '<leader>ff', remembered('find_files'), { desc = 'Find files (前回入力を保持)' })
    vim.keymap.set('n', '<leader>fg', remembered('live_grep'), { desc = 'Live grep (前回入力を保持)' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '前回の検索を完全復元' })
    vim.keymap.set('n', '<leader>fp', builtin.pickers, { desc = '検索履歴から再開' })
  end
}
