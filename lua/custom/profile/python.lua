local M = {}

local markers = { 'pyproject.toml', 'uv.lock', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }

local function is_executable(path)
  return path and path ~= '' and vim.fn.executable(path) == 1
end

local function add_candidate(candidates, path)
  if path and path ~= '' then table.insert(candidates, path) end
end

local function uv_environment_python(root)
  local env = vim.env.UV_PROJECT_ENVIRONMENT
  if not env or env == '' then return nil end

  local path = env
  if not vim.startswith(path, '/') and root then path = vim.fs.joinpath(root, path) end
  return vim.fs.joinpath(path, 'bin', 'python')
end

function M.root(bufnr)
  local name = bufnr and vim.api.nvim_buf_get_name(bufnr) or ''
  local start = name ~= '' and vim.fs.dirname(name) or vim.uv.cwd()
  return vim.fs.root(start, markers) or vim.uv.cwd()
end

function M.python_path(root)
  root = root or M.root()
  local candidates = {}

  add_candidate(candidates, uv_environment_python(root))
  if root then
    add_candidate(candidates, vim.fs.joinpath(root, '.venv', 'bin', 'python'))
    add_candidate(candidates, vim.fs.joinpath(root, 'venv', 'bin', 'python'))
  end
  add_candidate(candidates, vim.env.VIRTUAL_ENV and vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python'))
  add_candidate(candidates, vim.env.CONDA_PREFIX and vim.fs.joinpath(vim.env.CONDA_PREFIX, 'bin', 'python'))

  for _, candidate in ipairs(candidates) do
    if is_executable(candidate) then return candidate end
  end

  local python3 = vim.fn.exepath 'python3'
  if python3 ~= '' then return python3 end
  return 'python'
end

function M.debugpy_python()
  local mason_debugpy = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'packages', 'debugpy', 'venv', 'bin', 'python')
  if is_executable(mason_debugpy) then return mason_debugpy end
  return M.python_path()
end

return M
