local local_map = vim.api.nvim_buf_set_keymap

local default_opts = { noremap = true, silent = true }
local_map(0, 'n', 'q', ':close<CR>', default_opts)
