{lib, ...}: let
  scanUtils = import ./scan-modules.nix {inherit lib;};
in
  scanUtils
  // {
    # 以项目录根目录为基础路径
    root = lib.path.append ../.;
  }
