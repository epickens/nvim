return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        enabled = false,
        auto_refresh = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        accept = false, -- disable built-in keymapping
        keymap = {
          accept = '<C-a>',
          accept_word = false,
          accept_line = false,
          next = '<C-]>',
          prev = '<C-[>',
          dismiss = '<C-\\>',
        },
      },
    }

    --       suggestion = {
    --         enabled = true,
    --         auto_trigger = true,
    --         debounce = 75,
    --       },
    -- hide copilot suggestions when cmp menu is open
    -- to prevent odd behavior/garbled up suggestions
    local cmp_status_ok, cmp = pcall(require, 'cmp')
    if cmp_status_ok then
      cmp.event:on('menu_opened', function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on('menu_closed', function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end
  end,
}
