local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
    insert_mode = generic_opts_any,
    normal_mode = generic_opts_any,
    visual_mode = generic_opts_any,
    visual_block_mode = generic_opts_any,
    command_mode = generic_opts_any,
    term_mode = { silent = true },
}

local mode_adapters = {
    insert_mode = "i",
    normal_mode = "n",
    term_mode = "t",
    visual_mode = "v",
    visual_block_mode = "x",
    command_mode = "c",
}

local defaults = {
    -- change or add keymappings for insert mode
    insert_mode = {
        -- 'jk' for quitting insert mode
        ["jk"] = "<ESC>",
        -- Move current line / block with Alt-j/k ala vscode.
        ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
        ["<A-k>"] = "<Esc>:m .-2<CR>==gi",
    },

    -- change or add keymappings for normal mode
    normal_mode = {
        -- Better window movement
        ["<C-h>"] = "<C-w>h",
        ["<C-j>"] = "<C-w>j",
        ["<C-k>"] = "<C-w>k",
        ["<C-l>"] = "<C-w>l",

        -- Resize windows
        ["<C-S-h>"] = ":vertical resize -2<CR>",
        ["<C-S-j>"] = ":resize +2<CR>",
        ["<C-S-k>"] = ":resize -2<CR>",
        ["<C-S-l>"] = ":vertical resize +2<CR>",

        -- Tab switch buffer
        ["<S-l>"] = ":bnext<CR>",
        ["<S-h>"] = ":bprev<CR>",

        -- Move current line / block with Alt-j/k a la vscode.
        ["<A-j>"] = ":m .+1<CR>==",
        ["<A-k>"] = ":m .-2<CR>==",

        -- QuickFix
        ["]q"] = ":cnext<CR>",
        ["[q"] = ":cprev<CR>",
        ["<C-q>"] = ":call QuickFixToggle()<CR>",
    },

    -- change or add keymappings for terminal mode
    term_mode = {
        -- Terminal window navigation
        ["<C-h>"] = "<C-\\><C-N><C-w>h",
        ["<C-j>"] = "<C-\\><C-N><C-w>j",
        ["<C-k>"] = "<C-\\><C-N><C-w>k",
        ["<C-l>"] = "<C-\\><C-N><C-w>l",
    },

    -- change or add keymappings for visual mode
    visual_mode = {
        -- Better indenting
        ["<"] = "<gv",
        [">"] = ">gv",

        -- ["p"] = '"0p',
        -- ["P"] = '"0P',
    },

    -- change or add keymappings for visual block mode
    visual_block_mode = {
        -- Move selected line / block of text in visual mode
        ["K"] = ":move '<-2<CR>gv-gv",
        ["J"] = ":move '>+1<CR>gv-gv",

        -- Move current line / block with Alt-j/k ala vscode.
        ["<A-j>"] = ":m '>+1<CR>gv-gv",
        ["<A-k>"] = ":m '<-2<CR>gv-gv",
    },

    -- change or add keymappings for command mode
    command_mode = {
        -- navigate tab completion with <c-j> and <c-k>
        -- runs conditionally
        ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
        ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
    },
}

function M.append_to_defaults(keymaps)
    for mode, mappings in pairs(keymaps) do
        for k, v in pairs(mappings) do
            defaults[mode][k] = v
        end
    end
end

function M.clear(keymaps)
    local default = M.get_defaults()
    for mode, mappings in pairs(keymaps) do
        local translated_mode = mode_adapters[mode] or mode
        for key, _ in pairs(mappings) do
            -- some plugins may override default bindings that the user hasn't manually overridden
            if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
                pcall(vim.api.nvim_del_keymap, translated_mode, key)
            end
        end
    end
end

function M.set_keymaps(mode, key, val)
    local opt = generic_opts[mode] or generic_opts_any
    if type(val) == "table" then
        opt = val[2]
        val = val[1]
    end
    if val then
        vim.api.nvim_set_keymap(mode, key, val, opt)
    else
        pcall(vim.api.nvim_del_keymap, mode, key)
    end
end

-- Load key mappings for a given mode
function M.load_mode(mode, keymaps)
    mode = mode_adapters[mode] or mode
    for k, v in pairs(keymaps) do
        M.set_keymaps(mode, k, v)
    end
end

-- Load key mappings for all provided modes
function M.load(keymaps)
    keymaps = keymaps or {}
    for mode, mapping in pairs(keymaps) do
        M.load_mode(mode, mapping)
    end

    vim.g.mapleader = ";"
end

function M.load_defaults()
    M.load(M.get_defaults())
    keys = {}
    for idx, _ in pairs(defaults) do
        keys[idx] = {}
    end
end

-- Get the default keymappings
function M.get_defaults()
    return defaults
end

return M
