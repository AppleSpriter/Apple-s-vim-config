-- 1. 自动下载插件管理器 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)


-- 2. 安装 LSP 相关插件
require("lazy").setup({
    -- [核心：LSP 服务] 为了精准跳转 nn.Linear 等源码
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    -- [替代 CtrlP] Telescope: 极其强大的模糊搜索
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- [替代 NERDTree] nvim-tree: 现代文件浏览器
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- [替代 vim-airline] lualine: 极速 Lua 状态栏
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- [滚动插件修复版]
    {
        "karb94/neoscroll.nvim",
        config = function()
            require('neoscroll').setup({
                mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
                hide_cursor = true,          -- 滚动时隐藏光标
                stop_eof = true,             -- 滚动到文件末尾停止
                respect_scrolloff = false,   -- 保持光标相对位置
                cursor_scrolls_alone = true, -- 即使到达边界光标也移动
            })
        end
    },
    -- [跳转] 替代 EasyMotion 的神器: flash.nvim
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        keys = {
            -- 核心快捷键：按 s 键开始瞬移
            { "\\", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            -- 针对树形选择（比如想选定一个函数块）
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            -- 在跳转中搜索
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        },
    },
    -- 代码大纲插件
    {
        'stevearc/aerial.nvim',
        opts = {},
        -- 依赖：需要 treesitter 来解析函数
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require('aerial').setup({
                -- 自动关闭（当跳转到函数后自动关闭侧边栏）
                close_on_select = false, 
                -- 布局设置
                layout = {
                    min_width = 30,
                    default_direction = "right",
                },
            })
        end
    },
    -- [补全引擎] 现代补全方案
    {
    "hrsh7th/nvim-cmp",
            dependencies = {
            "hrsh7th/cmp-nvim-lsp",     -- 让 cmp 支持 LSP 补全
            "hrsh7th/cmp-buffer",       -- 补全当前文件里的关键词
            "hrsh7th/cmp-path",         -- 补全文件路径
            "L3MON4D3/LuaSnip",         -- 代码片段引擎
            "saadparwaiz1/cmp_luasnip", -- 让 cmp 支持代码片段
            "onsails/lspkind.nvim",     -- 为补全添加 VS Code 般的图标
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                -- 界面美化：添加边框和图标
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text', 
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                },
                -- 快捷键设置
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                -- 补全源优先级（LSP 最优先，然后是路径和缓存）
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', priority = 1000 },
                    { name = 'luasnip', priority = 750 },
                    { name = 'buffer', priority = 500 },
                    { name = 'path', priority = 250 },
                })
            })
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = "sh -c 'cd app && sh ./install.sh'",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        keys = {
            { "<F5>", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },
}
)

-- ==========================================
-- 3. 基础设置
-- ==========================================
vim.g.mapleader = " "          -- 设置 Leader 键为空格
vim.opt.number = true          -- 显示行号
vim.opt.relativenumber = true  -- 相对行号
vim.opt.shiftwidth = 4         -- 缩进
vim.opt.tabstop = 4
vim.opt.expandtab = true       -- 空格替换 Tab
vim.opt.cursorline = true      -- 高亮当前行
vim.opt.termguicolors = true   -- 启用真彩色支持（重要！）

-- F4 全局粘贴
vim.g.paste_model = 0
local function toggle_paste()
    if vim.g.paste_model == 1 then
        vim.opt.paste = false
        vim.g.paste_model = 0
        print("Paste Mode: OFF") -- 可选：在下方状态栏提示
    else
        vim.opt.paste = true
        vim.g.paste_model = 1
        print("Paste Mode: ON")
    end
end
vim.keymap.set('n', '<F4>', toggle_paste, { silent = true, desc = "Toggle Paste Mode" })

-- 全局粘贴
vim.g.show_number = 1
local function toggle_number()
    if vim.g.show_number == 1 then
        vim.mouse = ""
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.g.show_number = 0
        print("Focus Mode: ON (No numbers/mouse)") -- 提示
    else
	    vim.opt.mouse = "a"
	    vim.opt.number = true
	    vim.opt.relativenumber = true
	    vim.g.show_number = 1
	    print("Focus Mode: OFF (Numbers/mouse enabled)")
    end
end
vim.keymap.set('n', '<F2>', toggle_number, { silent = true, desc = "Toggle Number and Mouse" })

-- ==========================================
-- 4. 插件初始化设置
-- ==========================================
require("nvim-tree").setup()
require("lualine").setup({ options = { theme = 'dracula' } })

-- Mason 基础设置
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright" } 
})

local function get_python_path()
    -- 如果你激活了 conda 环境，环境变量里会有 VIRTUAL_ENV 或 CONDA_PREFIX
    local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
    if venv then
        -- macOS/Linux 路径是 /bin/python，Windows 是 /python.exe
        local path = venv .. "/bin/python"
        return path
    end
    -- 兜底使用系统 python
    return "python3"
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

if vim.lsp.config then
    -- Neovim 0.11+ 规范
    vim.lsp.config('pyright', {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        capabilities = capabilities,
        -- 核心：告诉 Pyright 去哪里找 torch 等库
        settings = {
            python = {
                pythonPath = get_python_path(), -- 调用上面的函数
                analysis = {
                    useLibraryCodeForTypes = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                },
            },
        },
        root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
    })
    vim.lsp.enable('pyright')
else
    -- 兼容旧版 (lspconfig)
    require('lspconfig').pyright.setup({
        capabilities = capabilities,
        settings = {
            python = {
                pythonPath = get_python_path(),
                analysis = { useLibraryCodeForTypes = true }
            }
        }
    })
end

-- ==========================================
-- 5. 快捷键映射 (按你的习惯配置)
-- ==========================================
local keymap = vim.keymap.set
local opts = { silent = true }

-- [文件树] 依然用 F3 打开/关闭
keymap('n', '<F3>', ':NvimTreeToggle<CR>', opts)
-- 设置 F4 键打开/关闭函数列表
vim.keymap.set('n', '<F1>', '<cmd>AerialToggle!<CR>', { silent = true })

-- [Telescope] 替代 CtrlP 
-- 空格+ff 搜文件; 空格+fg 搜内容 (类似 grep)
keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
keymap('n', '<C-p>', ':Telescope find_files<CR>', opts) -- 保持 Ctrl+P 习惯

-- [LSP 定义跳转] 核心功能：看 Python 源码
-- -- 针对新版本优化的跳转
vim.keymap.set('n', 'gd', function()
    if vim.lsp.definition then
        vim.lsp.definition()
    else
        vim.lsp.buf.definition() -- 兼容旧版本
    end
end, opts)
vim.keymap.set('n', 'K', function()
    if vim.lsp.definition then
        vim.lsp.hover()
    else
        vim.lsp.buf.hover() -- 兼容旧版本
    end
end, opts)-- 查看函数签名/文档说明
-- 在新标签页 (Tab) 中打开定义
vim.keymap.set('n', 'gT', function()
    -- 先创建一个新标签页，再执行跳转
    vim.cmd('tab split') 
    if vim.lsp.definition then
        vim.lsp.definition()
    else
        vim.lsp.buf.definition()
    end
end, { desc = "Go to Definition in new Tab" })

-- 或者：在水平/垂直分屏中打开
vim.keymap.set('n', 'gv', function()
    vim.cmd('vsplit') -- 垂直分屏
    vim.lsp.buf.definition()
end)


