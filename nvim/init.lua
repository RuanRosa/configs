if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
      vim.log.levels.ERROR
    )
  end
end


vim.cmd('set signcolumn=no')
require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)

-- pirokaida do ruanzinho

vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

function Hello()
  local filename = vim.fn.expand '%:t'
  if not filename:match '_test.go' then
    print 'Not a test file'
    return
  end
  local test_name_ln = vim.fn.search('^func Test', 'cbnW')
  local test_namee = vim.fn.getline(test_name_ln)
  local test_name = vim.fn.match(test_namee, '^func Test(.+)%(')
  local module_path = vim.fn.expand '%:h'
  if not module_path:match '^/' then
    module_path = './' .. module_path
  end
  local cmd = 'rg --files --glob "*.go" | entr -r go test -race -count=1 -v -run="^Test' ..
      test_name .. '$" ' .. module_path
  vim.api.nvim_command 'vsplit'
  vim.api.nvim_command('terminal  ' .. cmd)
  vim.cmd 'startinsert'
end
