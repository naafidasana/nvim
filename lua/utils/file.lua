local M = {}

-- Move file to from `old_path` to `new_path`
M.move_file = function(args)
  local arguments = vim.split(args, " ", { trimempty = true })

  if #arguments < 2 then
    vim.notify("Usage: Mf `old_path` `new_path`", vim.log.levels.ERROR)
    return
  end

  local source_file = arguments[1]
  local target_path = arguments[2]
  local target_file = target_path

  if vim.fn.filereadable(source_file) == 0 then
    vim.notify("Source file doesn't exist: " .. source_file, vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory(target_path) == 1 then
    local filename = vim.fn.fnamemodify(source_file, ":t")
    target_file = target_path .. "/" .. filename
  else
    local target_dir = vim.fn.fnamemodify(target_path, ":h")
    if vim.fn.isdirectory(target_dir) == 0 then
      local create = vim.fn.confirm("Directory does not exist. Create it?", "&Yes\n&No", 1)
      if create == 1 then
        vim.fn.mkdir(target_dir, "p")
      else
        return
      end
    end
  end

  if vim.fn.filereadable(target_file) == 1 then
    local choice = vim.fn.confirm("File already exists. Overwrite?", "&Yes\n&No", 2)
    if choice ~= 1 then
      return
    end
  end

  -- Move the file
  local success, err = pcall(function()
    vim.fn.rename(source_file, target_file)
  end)

  if success then
    if vim.fn.expand("%:p") == vim.fn.fnamemodify(source_file, ":p") then
      vim.cmd("edit " .. target_file)
    end
    vim.notify("File moved: " .. source_file .. " → " .. target_file, vim.log.levels.INFO)
  else
    vim.notify("Error: failed to move file: " .. err, vim.log.levels.ERROR)
  end
end

return M
