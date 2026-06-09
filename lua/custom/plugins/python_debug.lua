vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap-python',
}

local python_env = require 'custom.profile.python'
local dap = require 'dap'
local dapui = require 'dapui'

dapui.setup()
require('dap-python').setup(python_env.debugpy_python())

for _, config in ipairs(dap.configurations.python or {}) do
  config.pythonPath = function()
    return python_env.python_path()
  end
end

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<F7>', function() dapui.toggle() end, { desc = 'Debug: Toggle UI' })
vim.keymap.set('n', '<leader>dr', function() require('dap-python').test_method() end, { desc = 'Debug: Python test method' })
vim.keymap.set('n', '<leader>dR', function() require('dap-python').test_class() end, { desc = 'Debug: Python test class' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
