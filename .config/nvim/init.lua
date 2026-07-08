-- COQ settings
vim.g.coq_settings = {
    clients = {
        snippets = {
            weight_adjust = -1
        },
        buffers = {
            weight_adjust = -2
        }
    }
}

-- Plugins
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1.x' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/folke/trouble.nvim' },
    { src = 'https://github.com/folke/neoconf.nvim' },
    { src = 'https://github.com/ms-jpq/coq-nvim', version='coq' },
    { src = 'https://github.com/ms-jpq/coq.artifacts' },
    { src = 'https://github.com/shaunsingh/nord.nvim' },
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/AlexeySachkov/llvm-vim' },
})

local telescope = require('telescope.builtin')
local neoconf = require("neoconf")
local dap = require('dap')

neoconf.setup()

-- LSP
vim.lsp.config('texlab', {
    settings = {
        texlab = {
            build = {
                onSave = true,
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            },
            chktex = {
                onEdit = true
            },
        },
    }
})

vim.lsp.config('arduino_language_server', {
    cmd = {
        "arduino-language-server",
        "-cli-config",
        "sketch.yaml"
    },
    capabilities = {
        textDocument = {
            semanticTokens = vim.NIL
        },
        workspace = {
            semanticTokens = vim.NIL
        }
    },
    filetypes = { "arduino" }
})

vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end
})

vim.lsp.enable('texlab')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('jedi_language_server')
vim.lsp.enable('clangd')
vim.lsp.enable('arduino_language_server')
vim.lsp.enable('lua_ls')
vim.lsp.enable('hls')
vim.lsp.enable('zls')
vim.lsp.enable('tblgen_lsp_server')

-- DAP
dap.adapters.gdb = {
    id = 'gdb',
    type = 'executable',
    command = 'gdb',
    args = { '--quiet', '--interpreter=dap' }
}

dap.configurations.c = {
    {
        name = 'Run executable (GDB)',
        type = 'gdb',
        request = 'launch',
        -- This requires special handling of 'run_last', see
        -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
        program = function()
            local path = vim.fn.input({
                prompt = 'Path to executable: ',
                default = vim.fn.getcwd() .. '/',
                completion = 'file',
            })

            return (path and path ~= '') and path or dap.ABORT
        end,
    }
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

-- Keymap
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { border = "single" } end, opts)
        vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help { border = "single" } end, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ra', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>rf', function()
            vim.lsp.buf.format { async = true }
        end, opts)
        if client.name == "clangd" then
            vim.keymap.set('n', '<space>h', function()
                vim.cmd('LspClangdSwitchSourceHeader')
            end, opts)
        end
    end,
})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<space>E', vim.diagnostic.setloclist)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1 } end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1 } end)

vim.keymap.set('n', '<space>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<space>fb', telescope.buffers, { desc = 'Telescope buffers' })

vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<space>c', dap.continue)
vim.keymap.set('n', '<space>n', dap.step_over)
vim.keymap.set('n', '<space>so', dap.step_out)
vim.keymap.set('n', '<space>si', dap.step_into)

-- Options
vim.opt.keymap = "russian-jcukenwin"
vim.opt.fileencodings = 'utf8,cp1251'
vim.opt.iminsert = 0

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.so = 5
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"

-- Appearance
vim.g.nord_borders = true
vim.g.nord_uniform_diff_background = true
vim.cmd.colorscheme("nord")
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "fg" })
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'LspDiagnosticsSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '→', texthl = 'LspDiagnosticsSignWarning', linehl = '', numhl = '' })
vim.diagnostic.config { float = { border = "single" } }
