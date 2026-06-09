vim.pack.add { 'https://github.com/zbirenbaum/copilot.lua' }

require('copilot').setup {
  copilot_node_command = vim.fn.expand '$HOME/.nvm/versions/node/v22.22.3/bin/node',
  panel = {
    enabled = false,
    auto_refresh = false,
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    accept = false,
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

local cmp_status_ok, cmp = pcall(require, 'cmp')
if cmp_status_ok then
  cmp.event:on('menu_opened', function()
    vim.b.copilot_suggestion_hidden = true
  end)

  cmp.event:on('menu_closed', function()
    vim.b.copilot_suggestion_hidden = false
  end)
end
