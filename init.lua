local vim = vim
local opt = vim.opt
local g = vim.g
local cmd = vim.cmd -- execute Vim commands

---------------------
require('misc_utils')
---------------------

--------------------
-- Basic
--------------------

g.XkbSwitchEnabled = 1        -- ?

opt.encoding = 'UTF-8'        -- set encoding

opt.mouse = 'a'               -- enable mouse

opt.number = true             -- show line of numbers

opt.showcmd = true            -- show last command in bottom bar

opt.cursorline = true         -- highlight current line

opt.wildmenu = true           -- visual autocomplete for command menu

opt.lazyredraw = true         -- redraw only when we need to

opt.showmatch = true          -- highlight mathching [{()}]

opt.clipboard = 'unnamedplus' -- enable clipboard in nvim

-- opt.relativenumber = true -- relative number lines

opt.so = 999           -- cursor in screen center

opt.undofile = true    -- undo file

opt.breakindent = true -- wrap text with same indentation

opt.splitbelow = true

opt.linebreak = true -- Stop Vim wrapping lines in the middle of a word

opt.formatoptions:remove { "t", "c" }

-- Enable filetype plugin
cmd [[filetype plugin on]]

-------------------------
-- Keymaps
-------------------------

local map = vim.api.nvim_set_keymap
local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- set leader key
g.mapleader = ","
g.maplocalleader = ","


-- skip fake lines
map('n', 'j', 'gj', default_opts)
map('n', 'k', 'gk', default_opts)

-------------------------
-- Search
-------------------------

opt.incsearch = true                               -- search as characters are entered

opt.hlsearch = true                                -- highlight mathches

opt.ignorecase = true                              -- ignoring case in search

map('n', '<C-f>', ':nohlsearch<CR>', default_opts) -- hide search mathes

--------------------------
-- Splits
--------------------------

-- Use ctrl-[hjkl] to select the active split
map('n', '<C-k>', ':wincmd k<CR>', default_opts)
map('n', '<C-j>', ':wincmd j<CR>', default_opts)
map('n', '<C-h>', ':wincmd h<CR>', default_opts)
map('n', '<C-l>', ':wincmd l<CR>', default_opts)

-------------------------
-- Colorscheme
-------------------------

cmd 'colorscheme tokyonight' -- set colorscheme

opt.termguicolors = true     -- set true colors

--------------------------
-- Tabs and spaces
-------------------------

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
opt.expandtab = true                        -- tab is spaces

augroup('setLangIndent', { clear = true })

augroup('miscSetup', { clear = true })

-- Set indentation to 2 spaces for specified file types
autocmd('Filetype', {
  group = 'setLangIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua', 'yaml', 'haskell', 'scala', 'purescript', 'nix', 'markdown', 'vim', 'svelte'
  },
  command = 'setlocal shiftwidth=2 softtabstop=2'
})

-- Golang indent setup
autocmd('Filetype', {
  group = 'setLangIndent',
  pattern = { 'go' },
  command = 'setlocal noexpandtab copyindent preserveindent softtabstop=0 shiftwidth=4 tabstop=4 fileformat=unix'
})

-- Python indent setup
autocmd('Filetype', {
  group = 'setLangIndent',
  pattern = { 'python' },
  command = 'setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix'
})

-- Enter insert mode when switching to terminal
autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

--------------------------
-- Buffers
--------------------------

-- Close terminal buffer on process exit
autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert'
})

-- buffer settings
opt.hidden = true

-- previous buffer key
map('n', '<S-h>', ':bprev<CR>', default_opts)

-- next buffer key
map('n', '<S-l>', ':bnext<CR>', default_opts)

-- quit neovim shortcut
map('n', '<C-q>', ':qa<CR>', default_opts)

-- close buffer
map('n', '<C-w>', ':bd!<CR>', default_opts)

-- closing buffer
-- cmd [[nnoremap <c-w> :lua Close_buffer()<CR>]]
-- function Close_buffer()
--   local view = require "nvim-tree.view"
--   local nvim_tree_api = require("nvim-tree.api")
--   if view.is_visible() then
--     nvim_tree_api.tree.close()
--     cmd [[bdel! %]]
--     nvim_tree_api.tree.open()
--     cmd [[wincmd l]]
--   else
--     cmd [[bdel! %]]
--   end
-- end

--------------------
-- Comments
--------------------

-- Don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Enable nix comments
autocmd('Filetype', {
  group = 'setLangIndent',
  pattern = { 'nix' },
  command = 'setlocal commentstring=#%s'
})

--------------------
-- PLUGINS
--------------------

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- PACKER INIT
require('packer').startup(function(use)
  use {
    'wbthomason/packer.nvim',
    branch = "master"
  }

  -- nvim-tree
  use {
    'nvim-tree/nvim-tree.lua',
    branch = "master",
  }

  -- Icons for nvim-tree
  use {
    'nvim-tree/nvim-web-devicons',
    branch = "master"
  }

  -- Colorscheme
  use {
    'folke/tokyonight.nvim',
    branch = "main"
  }

  -- Bufferline
  use {
    'akinsho/bufferline.nvim',
    tag = "v2.*"
  }

  -- display real css colors
  use {
    'https://github.com/ap/vim-css-color',
    branch = "master"
  }

  -- Comments
  use {
    'https://github.com/tpope/vim-commentary',
    branch = "master"
  }

  -- All the lua functions I don't want to write twice.
  use {
    "nvim-lua/plenary.nvim",
    tag = "v0.1.3"
  }

  -- Todo highlight
  use {
    "folke/todo-comments.nvim",
    tag = "v1.1.0"
  }

  -- Bottom line
  use {
    'https://github.com/nvim-lualine/lualine.nvim',
    branch = "master",
  }

  -- Indent guides
  use {
    'https://github.com/lukas-reineke/indent-blankline.nvim',
    branch = "master",
  }

  -- Smart auto-pair
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }

  -- Nvim-lspconfig
  use {
    "https://github.com/neovim/nvim-lspconfig",
    branch = "master"
  }

  -- Auto-session manager
  use {
    'rmagatti/auto-session',
    branch = "main",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end
  }

  -- Treesitter support
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = "master"
  }

  -- LSP autocompletion
  use {
    'hrsh7th/cmp-nvim-lsp',
    branch = "main"
  }

  use {
    'hrsh7th/cmp-buffer',
    branch = "main"
  }
  use {
    'hrsh7th/cmp-path',
    branch = "main"
  }
  use {
    'hrsh7th/cmp-cmdline',
    branch = "main"
  }
  use {
    'hrsh7th/nvim-cmp',
    branch = "main"
  }

  use {
    'https://github.com/saadparwaiz1/cmp_luasnip',
    branch = "master"
  }

  use {
    'https://github.com/L3MON4D3/LuaSnip',
    branch = "master"
  }

  -- Java LSP client plugin
  use {
    'https://github.com/mfussenegger/nvim-jdtls',
    branch = "master"
  }

  -- Find, Filter, Preview, Pick.
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
  }

  -- nvim-dap client
  use {
    'https://github.com/mfussenegger/nvim-dap',
    branch = "master"
  }

  -- dap ui
  use {
    'https://github.com/rcarriga/nvim-dap-ui',
    branch = "master"
  }

  -- Scala lsp: nvim-metals
  use {
    'scalameta/nvim-metals',
    requires = { "nvim-lua/plenary.nvim" },
    branch = "main"
  }
end)


-- NVIM-TREE
function NvimTreeSetup()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- leader-g open tree
  map(
    'n',
    '<leader>g',
    ':NvimTreeToggle<CR>',
    default_opts
  )

  require("nvim-tree").setup({
    renderer = {
      group_empty = true,
    },
    filters = {
      git_ignored = false,
      dotfiles = false,
      git_clean = false,
      no_buffer = false,
      custom = {},
      exclude = {},
    }
  })
end

NvimTreeSetup()


-- BUFFERLINE
function BufferLineSetup()
  require('bufferline').setup {
    options = {
      mode = "buffers",                    -- set to "tabs" to only show tabpages instead
      close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
      -- close_command = "NvimTreeClose",       -- can be a string | function, see "Mouse actions"
      right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
      -- NOTE: this plugin is designed with this icon in mind,
      -- and so changing this is NOT recommended, this is intended
      -- as an escape hatch for people who cannot bear it for whatever reason
      indicator = {
        icon = '▎', -- this should be omitted if indicator style is not 'icon'
        style = 'icon',
      },
      buffer_close_icon = '',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
    },
  }
end

BufferLineSetup()

-- NVIM-LSPCONFIG
function NvimLspConfigSetup()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require('lspconfig').tsserver.setup {}
  require('lspconfig').svelte.setup {}
  require('lspconfig').cssls.setup {}
  require('lspconfig').pyright.setup {}
  require('lspconfig').hls.setup {
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
  }
  require('lspconfig').html.setup {
    capabilities = capabilities
  }
  require('lspconfig').lua_ls.setup {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            library = { vim.env.VIMRUNTIME }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      return true
    end
  }

  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  keymap('n', '<space>e', vim.diagnostic.open_float)
  keymap('n', '[d', vim.diagnostic.goto_prev)
  keymap('n', ']d', vim.diagnostic.goto_next)
  keymap('n', '<space>q', vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  autocmd('LspAttach', {
    group = augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      keymap('n', 'gD', vim.lsp.buf.declaration, opts)
      keymap('n', 'gd', vim.lsp.buf.definition, opts)
      keymap('n', 'K', vim.lsp.buf.hover, opts)
      keymap('n', 'gi', vim.lsp.buf.implementation, opts)
      keymap('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      keymap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      keymap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      keymap('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      keymap('n', '<space>D', vim.lsp.buf.type_definition, opts)
      keymap('n', '<space>rn', vim.lsp.buf.rename, opts)
      keymap({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      keymap('n', 'gr', vim.lsp.buf.references, opts)
      keymap('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })
end

NvimLspConfigSetup()

function TreeSitterSetup()
  require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "java", "scala", "go", "haskell" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
      enable = true,
    },
    indent = {
      enable = false
    }
  }
end

TreeSitterSetup()

function NvimCmpSetup()
  -- Add additional capabilities supported by nvim-cmp
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local lspconfig = require('lspconfig')

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  local servers = { 'lua_ls' }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      -- on_attach = my_custom_on_attach,
      capabilities = capabilities,
    }
  end

  -- luasnip setup
  local luasnip = require 'luasnip'

  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    -- disable preselect
    preselect = cmp.PreselectMode.None,
    completeopt = {
      "menu",
      "menuone",
      "noselect",
      "noinsert"
    },

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
      ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
      -- C-b (back) C-f (forward) for snippet placeholder navigation.
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    },
  }

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

NvimCmpSetup()

---- TELESCOPE SETUP
function TelescopeSetup()
  map('n', '<leader>ff', ':Telescope find_files hidden=true<CR>', default_opts)
  map('n', '<leader>fg', ':Telescope live_grep<CR>', default_opts)
  map('n', '<leader>fb', ':Telescope buffers<CR>', default_opts)
  map('n', '<leader>fh', ':Telescope help_tags<CR>', default_opts)

  local actions = require "telescope.actions"

  require('telescope').setup {
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      file_ignore_patterns = { ".git/" },
      mappings = {
        i = {
          ["<esc>"] = require('telescope.actions').close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        }
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden'
      },
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
    }
  }
end

TelescopeSetup()

function NvimDapSetup()
  vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
  vim.fn.sign_define('DapStopped', { text = '🔵', texthl = '', linehl = '', numhl = '' })

  keymap('n', '<F10>', function() require('dap').step_over() end, default_opts)
  keymap('n', '<F11>', function() require('dap').step_into() end, default_opts)
  keymap('n', '<F12>', function() require('dap').step_out() end, default_opts)
  keymap('n', '<leader>dc', function() require('dap').continue() end, default_opts)
  keymap('n', '<leader>dt', function()
    local dap = require('dap')
    local dapui = require('dapui')
    dap.terminate()
    dap.close()
    dapui.close()
    dap.repl.close()
  end, default_opts)
  keymap('n', '<leader>db', function() require('dap').toggle_breakpoint() end, default_opts)
  keymap('n', '<leader>dm', function() require('dap').clear_breakpoints() end, default_opts)
  keymap('n', '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    default_opts)
  keymap('n', '<leader>lr', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    default_opts)
  keymap('n', '<leader>dr', function() require('dap').repl.open() end, default_opts)
  keymap({ 'n', 'v' }, '<leader>dh', function()
    require('dap.ui.widgets').hover()
  end)
  keymap({ 'n', 'v' }, '<leader>dp', function()
    require('dap.ui.widgets').preview()
  end)
  keymap('n', '<leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
  end)
  keymap('n', '<leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
  end)

  require('dap.ext.vscode').load_launchjs()
end

NvimDapSetup()

-- TODO COMMENTS SETUP
function TodoCommentsSetup()
  require("todo-comments").setup {}

  -- Search todo via Telescope plugin
  map('n', '<leader>ft', ':TodoTelescope<CR>', default_opts)
end

TodoCommentsSetup()


-- DAP-UI
function DapUiSetup()
  local dapui = require('dapui')
  local dap = require('dap')
  dapui.setup()

  -- Add dap ui to dap
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    dap.repl.close()
    dap.repl.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end
end

DapUiSetup()

-- INDENT-BLANKLINE (INDENT GUIDES)
function IndentBlanklineSetup()
  require("ibl").setup({
    scope = { enabled = false },
  })
end

IndentBlanklineSetup()

-- Nvim-metals (Scala lsp)
function NvimMetalsSetup()
  local metals_config = require("metals").bare_config()

  metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = {},
  }

  -- Showing useful info in status bar, but status bar must to support this
  metals_config.init_options.statusBarProvider = "on"

  metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Debug settings if you're using nvim-dap
  local dap = require("dap")

  -- dap.configurations.scala = {
  --   {
  --     type = "scala",
  --     request = "launch",
  --     name = "RunOrTest",
  --     metals = {
  --       runType = "runOrTestFile",
  --     },
  --   },
  -- }

  metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
  end

  -- Autocmd that will actually be in charging of starting the whole thing
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    -- java support is excluded
    pattern = { "scala", "sbt" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
end

NvimMetalsSetup()

function LuaLineSetup()
  local function scalaMetals()
    if vim.g['metals_status'] then
      return vim.g['metals_status']
    else
      return ''
    end
  end
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename', scalaMetals },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
end

LuaLineSetup()
