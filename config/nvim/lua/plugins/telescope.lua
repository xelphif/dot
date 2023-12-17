return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    -- Default configuration for telescope goes here:
                    -- config_key = value,
                    -- ..
                    color_devicons = true,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-h>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                        },
                    },
                    file_sorter = {
                        "rg",
                        "files",
                        "hidden",
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
                    fzf = {
                        fuzzy = true,        -- false will only do exact matching
                        override_generic_sorter = false, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    -- Your extension configuration goes here:
                    -- extension_name = {
                    --   extension_config_key = value,
                    -- }
                    -- please take a look at the readme of the extension you want to configure
                },
            })

            require("telescope").load_extension("fzf")

            -- mappings
            vim.api.nvim_set_keymap(
                "n",
                "<leader>f",
                ":Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>",
                {}
            )
            vim.api.nvim_set_keymap(
                "n",
                "<leader>F",
                ":Telescope find_files find_command=rg,--ignore,--hidden,--files cwd=~/<CR>",
                {}
            )
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
