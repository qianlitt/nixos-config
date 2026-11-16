# 打包指南

## 新增一个包

以 `modules/pkgs/foo/` 为例：

```nix
# package.nix
{
  perSystem = {pkgs, ...}: {
    packages.foo = pkgs.stdenvNoCC.mkDerivation rec {
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
    };
}
```

### 需要依赖另一个自打包的包

可以从 `config.packages` 取，不要重复写派生。见 `modules/pkgs/rime-data-tiger/package.nix`：

```nix
{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.rime-data-tiger = pkgs.runCommand "huma-rime-rime-data" {} ''
      mkdir -p $out/share/rime-data
      cp -r ${config.packages.huma-rime}/. $out/share/rime-data/
    '';
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
    stylix.cursor.package = ps.rose-pine-cursor;
  };
}
```
