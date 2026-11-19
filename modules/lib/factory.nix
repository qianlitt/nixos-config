{lib, ...}: {
  # 声明 flake 输出 factory
  options.flake.factory = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };
}
