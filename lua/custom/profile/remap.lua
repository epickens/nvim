-- enter normal mode
vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')

-- quit
vim.keymap.set('i', '<C-q>', '<Esc>:q!<cr>')
vim.keymap.set('n', '<C-q>', ':q!<cr>')

-- save
vim.keymap.set('i', '<C-s>', '<Esc>:w<cr>')
vim.keymap.set('n', '<C-s>', ':w<cr>')

-- paste without losing buffer
vim.keymap.set('x', '<leader>p', [["_dP]])

-- delete without yanking
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- copy xto system buffer
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- enter terminal mode
vim.keymap.set('n', '<leader>ft', ':terminal <Enter>i')

--split window
vim.keymap.set('n', '<leader>|', ':vsplit <Enter>')
vim.keymap.set('n', '<leader>-', ':split <Enter>')

-- copilot remaps
vim.keymap.set('n', '<leader>coe', ':Copilot enable<cr>')
vim.keymap.set('n', '<leader>cod', ':Copilot disable<cr>')
