
-- vim.opt.vfile = "C:/Users/Lightja/AppData/Local/nvim/nvim_log.txt"
-- vim.opt.verbose = 10

require("profile.1-lazy")
require("profile.2-functions")
require("profile.3-plugin_config")
require("profile.4-set")
require("profile.5-remap")
ColorMyPencils()


vim.cmd("command! -bang -range ToggleSlash <line1>,<line2>lua ToggleSlash(<line1>, <line2>, tonumber(<bang>1) == 1)")
vim.cmd([[command! -nargs=* Move lua vim.fn.system('move /Y ' .. vim.fn.shellescape(<q-args>))]])


