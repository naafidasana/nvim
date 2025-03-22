local file_utils = require("utils.file")

vim.api.nvim_create_user_command("Mf", function(opts)
  file_utils.move_file(opts.args)
end, {
  nargs = "*",
  complete = "file",
  desc = "Move a file from `old_path` to `new_path`",
})
