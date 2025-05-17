return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Python
        pyright = {},

        -- C, C++, and CUDA
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--fallback-style=Google",
            "--cross-file-rename",
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cu" },
          root_dir = require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        },
      },
    },
  },
}
