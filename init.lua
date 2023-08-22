local vim = vim
local opt = vim.opt
local g = vim.g
local cmd = vim.cmd -- execute Vim commands

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
    'yaml', 'lua', 'yaml', 'haskell', 'scala', 'purescript', 'nix', 'markdown', 'vim'
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

-- Java indent setup
autocmd('Filetype', {
  group = 'setLangIndent',
  pattern = { 'java' },
  command = 'setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix'
})

-- Java nvim-jdtls run
autocmd('Filetype', {
  group = 'miscSetup',
  pattern = { 'java' },
  command = 'lua NvimJdtlsSetup()'
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
    config = function()
      require('lualine').setup()
    end
  }

  -- Indent guides
  use {
    'https://github.com/lukas-reineke/indent-blankline.nvim',
    branch = "master",
    config = function()
      require("indent_blankline").setup()
    end
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

  use {
    'https://github.com/mfussenegger/nvim-jdtls',
    branch = "master"
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

  require("nvim-tree").setup()
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
  -- require('lspconfig').jdtls.setup {}
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
      keymap({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
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
        select = true,
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

function NvimJdtlsSetup()
  -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
  local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = { "jdtls", "-configuration", "/home/user/.cache/jdtls/config", "-data", "/home/user/.cache/jdtls/workspace" },
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
      }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = {}
    },
  }
  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  require('jdtls').start_or_attach(config)
end

NvimJdtlsSetup()
