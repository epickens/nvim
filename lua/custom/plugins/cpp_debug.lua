vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
}

local dap = require 'dap'

local codelldb = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'packages', 'codelldb', 'extension', 'adapter', 'codelldb')
if vim.fn.executable(codelldb) == 1 then
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb,
      args = { '--port', '${port}' },
    },
  }
else
  dap.adapters.codelldb = {
    type = 'executable',
    command = 'codelldb',
  }
end

local function executable_prompt()
  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local launch_config = {
  name = 'Launch executable',
  type = 'codelldb',
  request = 'launch',
  program = executable_prompt,
  cwd = '${workspaceFolder}',
  stopOnEntry = false,
  args = {},
}

dap.configurations.c = { launch_config }
dap.configurations.cpp = { launch_config }
dap.configurations.cuda = { launch_config }
