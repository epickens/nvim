vim.filetype.add {
  extension = {
    cu = 'cuda',
    cuh = 'cuda',
    sbatch = 'sh',
    slurm = 'sh',
  },
}

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*',
  callback = function(args)
    if vim.bo[args.buf].filetype ~= '' then return end

    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 40, false)
    for _, line in ipairs(lines) do
      if line:match '^#SBATCH' then
        vim.bo[args.buf].filetype = 'sh'
        return
      end
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc' },
  callback = function(args)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    if vim.b[args.buf].large_json then
      vim.opt_local.list = false
      vim.opt_local.wrap = false
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'markdown.mdx' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.foldmethod = 'indent'

    vim.cmd.inoreabbrev '<buffer> true True'
    vim.cmd.inoreabbrev '<buffer> false False'
    vim.cmd.inoreabbrev '<buffer> none None'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'cuda', 'cmake' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'plaintex' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = 'nc'
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
