# 为 flake.modules 的每个条目派生稳定的 key。
# Nix 模块系统按 key 去重（genericClosure），而 flake-parts 包装模块时
# 只设置 _class / _file，没有设置 key，导致同一模块从不同位置导入时会被求值多次。
{
  config,
  lib,
  ...
}: {
  flake.lib.modules =
    lib.mapAttrs (
      class: modules:
        lib.mapAttrs (name: module: {
          key = "flake.modules.${class}.${name}";
          imports = [module];
        })
        modules
    )
    config.flake.modules;
}
