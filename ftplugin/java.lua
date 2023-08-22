local vim = vim
local local_map = vim.api.nvim_buf_set_keymap
local default_opts = { noremap = true, silent = true }

vim.cmd('setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix')

-- JDTLS SETUP
function NvimJdtlsSetup()
  local function isJdtlsAttached()
    local client_tbl = vim.lsp.get_active_clients()
    for index, data in ipairs(client_tbl) do
      for key, value in pairs(data) do
        if key == "name" then
          if value == "jdtls" then
            return true
          end
        end
      end
      return false
    end
  end

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
      bundles = {
        vim.fn.glob(
          "/home/user/.local/share/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.48.0.jar",
          1)
      },
    },
  }
  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  require('jdtls').start_or_attach(config)

  -- require('jdtls.dap').setup_dap_main_class_configs()
end

NvimJdtlsSetup()

local_map(0, 'n', '<leader>dj', ":JdtUpdateDebugConfig<CR>", default_opts)
