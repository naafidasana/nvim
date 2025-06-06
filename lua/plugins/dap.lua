return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")

          dapui.setup({
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.33 },
                  { id = "breakpoints", size = 0.33 },
                  { id = "stacks", size = 0.34 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 0.3,
                position = "bottom",
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            windows = {
              elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
                "repl",
                "console",
                "expression",
              },
            },
          })

          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
    },

    config = function()
      local dap = require("dap")

      -- Python debugger
      dap.adapters.python = {
        type = "executable",
        command = "python3",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return os.getenv("VIRTUAL_ENV") and os.getenv("VIRTUAL_ENV") .. "/bin/python" or "python3"
          end,
        },
      }

      -- C++ debugger (requires codelldb installed)
      dap.adapters.cpp = {
        type = "executable",
        command = "codelldb", -- use full path if needed
        args = { "--port", "${port}" },
      }

      dap.configurations.cpp = {
        {
          type = "cpp",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
      }

      -- Keymaps
      vim.api.nvim_set_keymap("n", "<F5>", ':lua require("dap").continue()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F10>", ':lua require("dap").step_over()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F11>", ':lua require("dap").step_into()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F12>", ':lua require("dap").step_out()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>b",
        ':lua require("dap").toggle_breakpoint()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>B",
        ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dr",
        ':lua require("dap").repl.toggle()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dl",
        ':lua require("dap").run_last()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>du",
        ':lua require("dapui").toggle()<CR>',
        { noremap = true, silent = true }
      )
    end,
  },
}
