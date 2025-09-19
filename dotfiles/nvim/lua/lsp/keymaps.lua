-- Only set non-default LSP keymaps
local function on_attach(client, bufnr)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Additional useful keymaps (not Neovim defaults)
  -- gd is very common and worth keeping even though not a default
  map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })

  -- Formatting with gq (native vim keybind for formatting)
  if client.supports_method("textDocument/formatting") then
    map("n", "gq", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format Buffer" })
  end

  -- Inlay hints toggle
  if client.supports_method("textDocument/inlayHint") then
    map("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, { desc = "Toggle Inlay Hints" })
  end
end

-- LSP management commands
vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Lsp Restart" })

-- Setup autocmd to attach keymaps when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      on_attach(client, event.buf)
    end
  end,
})