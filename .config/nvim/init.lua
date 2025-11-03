local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-------------------------------------------------------------
-- LSP
vim.g.coq_settings = {
    auto_start = 'shut-up',
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
require("lazy").setup {
    { "neovim/nvim-lspconfig" },
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    { "folke/trouble.nvim",       dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "ms-jpq/coq-nvim", branch = "coq" },
    { "ms-jpq/coq.artifacts" },
    { "doums/darcula",            lazy = true, priority = 1000 },
    { "shaunsingh/nord.nvim",     lazy = true, priority = 1000 },
    { "stevearc/overseer.nvim", dependencies = { "nvim-telescope/telescope.nvim", "stevearc/dressing.nvim" } },
    { "mfussenegger/nvim-dap" },
    { "AlexeySachkov/llvm-vim" }
}

local telescope = require('telescope.builtin')
local overseer = require('overseer')
local lsp = require('lspconfig')
local coq = require('coq')
local dap = require('dap')

overseer.setup()
lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities())
lsp.jedi_language_server.setup(coq.lsp_ensure_capabilities())
lsp.clangd.setup(coq.lsp_ensure_capabilities())
lsp.lua_ls.setup(coq.lsp_ensure_capabilities {
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
    end,
    settings = {
        Lua = {}
    }
})
lsp.hls.setup(coq.lsp_ensure_capabilities())
lsp.zls.setup(coq.lsp_ensure_capabilities())

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

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
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
    end,
})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<space>E', vim.diagnostic.setloclist)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1 } end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1 } end)

vim.keymap.set('n', '<space>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<space>fb', telescope.buffers, { desc = 'Telescope buffers' })

vim.keymap.set('n', '<space>o', function()
    overseer.run_template({}, function(task, _)
        if task then
            overseer.open()
        end
    end)
end, { desc = 'Overseer run' })

vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<space>c', dap.continue)
vim.keymap.set('n', '<space>n', dap.step_over)
vim.keymap.set('n', '<space>so', dap.step_out)
vim.keymap.set('n', '<space>si', dap.step_into)

-- Options
vim.opt.keymap = "russian-jcukenwin"
vim.opt.fileencodings= 'utf8,cp1251'
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

--vim.opt.laststatus = 3

-- Appearance
vim.g.nord_borders = true
vim.g.nord_uniform_diff_background = true
vim.cmd.colorscheme("nord")
vim.api.nvim_set_hl(0, "WinSeparator", { fg="fg" })
vim.fn.sign_define('DapBreakpoint',{ text ='●', texthl ='LspDiagnosticsSignError', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='→', texthl ='LspDiagnosticsSignWarning', linehl ='', numhl =''})
vim.diagnostic.config { float = { border = "single" } }

