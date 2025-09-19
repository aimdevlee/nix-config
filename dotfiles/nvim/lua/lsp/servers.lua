-- Server configurations
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
          },
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
    single_file_support = true,
  },
  nil_ls = {
    settings = {
      ["nil"] = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
    single_file_support = true,
  },
  ruby_lsp = {
    init_options = {
      formatter = "auto",
    },
    capabilities = {
      general = { positionEncodings = "utf-16" },
    },
  },
  sorbet = {
    cmd = { "bundle", "exec", "srb", "typecheck", "--lsp" },
    on_attach = function(client, _)
      if client.server_capabilities.sorbetShowSymbolProvider then
        vim.api.nvim_create_user_command("CopySymbolToClipboard", function()
          -- Get the current cursor position (1-based line, 0-based column)
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          local params = {
            textDocument = { uri = "file://" .. vim.api.nvim_buf_get_name(0) },
            -- Adjusting line number to match 0-based indexing for Sorbet's request.
            -- ref. https://github.com/sorbet/sorbet/blob/c73f3beb911f551e789210190c087006f46614f2/main/lsp/json_types.cc#L191
            position = { line = line - 1, character = col },
          }
          local result = client.request_sync("sorbet/showSymbol", params, 3000)

          -- copy symbol to clipboard
          for _, response in pairs(result) do
            if response.name then
              vim.fn.setreg("+", response.name)
            end
          end
        end, {})
      end
    end,
  },
  ts_ls = {
    init_options = {
      preferences = {
        includeInlayParameterNameHints = "all",
      }
    },
  },
  eslint = {
    root_dir = function(bufnr, on_dir)
      local root_file_patterns = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        "eslint.config.ts",
        "eslint.config.mts",
        "eslint.config.cts",
      }

      on_dir(vim.fs.dirname(vim.fs.find(root_file_patterns, { path = vim.loop.cwd() })[1]))
    end,
  }
}

-- Configure each server using vim.lsp.config
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

-- Enable configured servers
local server_names = vim.tbl_keys(servers)
vim.lsp.enable(server_names)

