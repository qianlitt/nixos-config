{
  osConfig,
  lib,
  ...
}: let
  nixosStylixEnabled = osConfig.modules.stylix.enable or false;
in
  lib.optionalAttrs nixosStylixEnabled {
    stylix.targets = {
      nixvim.colors.enable = false;
      vscode.enable = false; # VSCode 主题由插件提供
      noctalia-shell.enable = false;
      hyprland.colors.enable = false; # BUG: 当前 stylix 不能正确配置 decoration
    };
  }
