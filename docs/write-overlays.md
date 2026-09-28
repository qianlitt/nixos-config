# Overlay 编写指南

## 写一个 overlay

```nix
# modules/overlays/openldap.nix
{
  flake.overlays.openldap = _final: prev: {
    openldap = prev.openldap.overrideAttrs (_: {
      doCheck = false;
    });
  };
}
```

overlay 函数签名是 `final: prev: { ... }`。用 `prev.X` 取修改前的包，用 `final.X` 取应用本 overlay **之后**的包（互相引用时才需要，例如 `modules/overlays/fcitx5/default.nix` 里 `fcitx5-rime.override` 引用 `final.rime-data`）。

## 启用 overlay

```nix
nixpkgs.overlays = [
  inputs.self.overlays.openldap
];
```
