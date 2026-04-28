/**
* snacks.nvim - 插件合集
*
* Home Page: https://github.com/folke/snacks.nvim
*/
{mylib, ...}: {
  imports = mylib.scanModules ./.;

  programs.nixvim.plugins.snacks.enable = true;
}
