# 打包指南

## 新增一个包

以 `modules/pkgs/foo/` 为例，需要两个文件。

`mod.nix` —— flake-parts 模块，只负责声明：

```nix
{
  perSystem = {pkgs, ...}: {
    packages.foo = pkgs.callPackage ./_package.nix {};
  };
}
```

`_package.nix` —— 普通 `callPackage` 函数，参数由 `pkgs` 自动注入：

```nix
{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "foo";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "...";
    repo = "foo";
    rev = "...";
    hash = "sha256-...";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp foo $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "...";
    homepage = "...";
    license = licenses.mit;
  };
}
```

### 包依赖另一个自打包的包

从 `config.packages` 取，不要重复写派生。见 `modules/pkgs/rime-data-tiger/mod.nix`：

```nix
{
  perSystem = {config, pkgs, ...}: {
    packages.bar = pkgs.callPackage ./_package.nix {
      inherit (config.packages) foo;
    };
  };
}
```

## 使用自己的包

直接引用：

```nix
# modules/programs/desktop/stylix.nix（节选）
{inputs, ...}: {
  flake.modules.nixos.stylix = {config, lib, pkgs, ...}: let
    cfg = config.modules.desktop.stylix;

    # 本仓库自打包的派生，见 modules/pkgs/
    ps = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    config = lib.mkIf cfg.enable {
      stylix.cursor.package = ps.rose-pine-cursor;
    };
  };
}
```
