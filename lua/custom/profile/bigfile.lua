local M = {}

local json_size_limit = vim.g.large_json_size_limit or 1024 * 1024
local json_extensions = {
  json = true,
  jsonc = true,
  jsonl = true,
  ipynb = true,
}

local function extension(path)
  return vim.fn.fnamemodify(path, ':e'):lower()
end

function M.is_lightweight(bufnr)
  return vim.b[bufnr].large_file_lightweight == true
end

local function mark_lightweight_json(bufnr, path, size)
  vim.b[bufnr].large_file_lightweight = true
  vim.b[bufnr].large_json = true
  vim.b[bufnr].skip_lsp = true
  vim.b[bufnr].skip_treesitter = true
  vim.b[bufnr].skip_format_on_save = true
  vim.b[bufnr].large_file_size = size

  vim.notify(
    ('Large JSON mode: skipped LSP, Treesitter, and format-on-save for %s'):format(vim.fn.fnamemodify(path, ':t')),
    vim.log.levels.INFO
  )
end

vim.api.nvim_create_autocmd('BufReadPre', {
  group = vim.api.nvim_create_augroup('custom-large-file-mode', { clear = true }),
  callback = function(args)
    local path = args.file
    if path == '' or not json_extensions[extension(path)] then return end

    local stat = vim.uv.fs_stat(path)
    if stat and stat.size > json_size_limit then mark_lightweight_json(args.buf, path, stat.size) end
  end,
})

local function apply_lightweight_options(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not M.is_lightweight(bufnr) then return end

  vim.api.nvim_set_option_value('syntax', 'OFF', { buf = bufnr })
  vim.api.nvim_set_option_value('indentexpr', '', { buf = bufnr })
  vim.api.nvim_set_option_value('swapfile', false, { buf = bufnr })
  pcall(vim.treesitter.stop, bufnr)
  pcall(vim.diagnostic.enable, false, { bufnr = bufnr })

  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    pcall(vim.lsp.buf_detach_client, bufnr, client.id)
  end
end

vim.api.nvim_create_user_command('JsonLightMode', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  mark_lightweight_json(bufnr, path ~= '' and path or '[No Name]', 0)
  apply_lightweight_options(bufnr)
end, { desc = 'Disable heavy JSON features in the current buffer' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-large-json-filetype', { clear = true }),
  pattern = { 'json', 'jsonc' },
  callback = function(args)
    if not M.is_lightweight(args.buf) then return end

    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldenable = false
    apply_lightweight_options(args.buf)
    vim.schedule(function() apply_lightweight_options(args.buf) end)
  end,
})

vim.api.nvim_create_autocmd('Syntax', {
  group = vim.api.nvim_create_augroup('custom-large-json-syntax', { clear = true }),
  pattern = { 'json', 'jsonc' },
  callback = function(args) apply_lightweight_options(args.buf) end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('custom-large-json-window', { clear = true }),
  callback = function(args)
    if not M.is_lightweight(args.buf) then return end

    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldenable = false
    apply_lightweight_options(args.buf)
  end,
})

return M
