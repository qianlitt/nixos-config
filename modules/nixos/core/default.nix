/**
* core - NixOS 的核心配置
*/
{mylib, ...}: {
  imports = mylib.scanModules ./.;
}
