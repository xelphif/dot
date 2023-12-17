return {
    --
    -- core plugins
    --

    -- convenient language server installer
    "williamboman/nvim-lsp-installer",

    -- neovim lua utility library
    "nvim-lua/plenary.nvim",

    -- autopairs
    {
        "windwp/nvim-autopairs",
        config = true,
    },

    -- sandwich pairs
    {
        "kylechui/nvim-surround",
        version = "*",
        config = true,
    },

    -- set treesitter commentstring
    "JoosepAlviste/nvim-ts-context-commentstring",

    -- comments
    {
        "numToStr/Comment.nvim",
        config = true,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- better movement
    {
        "phaazon/hop.nvim",
        config = true,
        keys = {
            { "<leader>w", "<cmd>lua require'hop'.hint_words()<cr>", mode = { "n", "v" } },
            { "<leader>x", "<cmd>lua require'hop'.hint_lines()<cr>", mode = { "n", "v" } },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        config = true,
    },

    -- --
    -- -- cosmetic plugins
    -- --

    -- colorscheme
    {
        "sainnhe/sonokai",
        config = function()
            vim.g["sonokai_style"] = 'andromeda'
            vim.cmd([[colorscheme sonokai]])
        end,
    },

    -- dev icons for cmp
    "onsails/lspkind.nvim",

    -- splash screen
    {
        "goolord/alpha-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end,
    },

    -- indent markers
    {
        "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {},
    },
}
