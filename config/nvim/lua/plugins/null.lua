return {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        local completion = null_ls.builtins.completion

        return {
            sources = {
                formatting.clang_format,
                formatting.stylua.with({
                    args = { "--indent-type", "Spaces", "-" },
                }),
                code_actions.gitsigns,
            },
            on_attach = function(client, bufnr)
                local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            -- vim.lsp.buf.format({
                            --   bufnr = bufnr,
                            --   filter = function(client)
                            --     return client.name == "null-ls"
                            --   end,
                            -- })
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        }
    end,
}
