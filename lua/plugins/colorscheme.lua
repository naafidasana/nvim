return {
  -- "craftzdog/solarized-osaka.nvim",
  "ellisonleao/gruvbox.nvim",
  lazy = true,
  priority = 1000,
  opts = function()
    return {
      -- transparent = true, -- uncomment for solarized-osaka
      transparent_mode = true, -- uncomment for gruvbox
    }
  end,
}
