require("profile.packer")
require("profile.functions")
require("profile.plugin_config")
require("profile.set")
require("profile.remap")

ColorMyPencils()

vim.cmd("command! -bang -range ToggleSlash <line1>,<line2>lua ToggleSlash(<line1>, <line2>, tonumber(<bang>1) == 1)")



