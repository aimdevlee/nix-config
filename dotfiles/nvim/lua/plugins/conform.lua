-- Conform Code Formatting Configuration
return {
  "stevearc/conform.nvim",
  config = function()
    local opts = {
      notify_on_error = true,
      format_on_save = function(_)
        return {
          timeout_ms = 1000,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        ruby = { "syntax_tree" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        toml = { "taplo" },
        nix = { "nixfmt" },
      },
    }
    require("conform").setup(opts)
  end,
}
