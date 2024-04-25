-- return {
--   'zbirenbaum/copilot.lua',
--   cmd = 'Copilot',
--   build = ':Copilot auth',
--   opts = {
--     suggestion = { enabled = false },
--     panel = { enabled = false },
--     filetypes = {
--       markdown = true,
--       help = true,
--     },
--   },
-- }
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
          accept = '<C-l>',
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
-- return {
--   'zbirenbaum/copilot.lua',
--   cmd = 'Copilot',
--   build = ':Copilot auth',
--   event = 'InsertEnter',
--   dependencies = 'zbirenbaum/copilot-cmp',
--   config = function()
--     require('copilot').setup(require('copilot').setup {
--       panel = {
--         enabled = true,
--         auto_refresh = false,
--         keymap = {
--           jump_prev = '[[',
--           jump_next = ']]',
--           accept = '<CR>',
--           refresh = 'gr',
--           open = '<M-CR>',
--         },
--         layout = {
--           position = 'bottom', -- | top | left | right
--           ratio = 0.4,
--         },
--       },
--       suggestion = {
--         enabled = true,
--         auto_trigger = true,
--         debounce = 75,
--         keymap = {
--           accept = '<M-l>',
--           accept_word = false,
--           accept_line = false,
--           next = '<M-]>',
--           prev = '<M-[>',
--           dismiss = '<C-]>',
--         },
--       },
--       filetypes = {
--         yaml = false,
--         markdown = false,
--         help = false,
--         gitcommit = false,
--         gitrebase = false,
--         hgcommit = false,
--         svn = false,
--         cvs = false,
--         ['.'] = false,
--       },
--       copilot_node_command = 'node', -- Node.js version must be > 16.x
--       server_opts_overrides = {},
--     })
--     require('copilot_cmp').setup {
--       formatters = {
--         insert_text = require('copilot_cmp.format').remove_existing,
--       },
--     }
--   end,
-- }
