{
  config,
  lib,
  inputs,
  mylib,
  osConfig,
  ...
}: let
  cfg = config.modules.desktop.quickshell.noctalia;

  nixosNoctaliaEnabled = osConfig.modules.desktop.quickshell.noctalia.enable or false;
in {
  imports =
    mylib.scanModules ./.
    ++ [inputs.noctalia.homeModules.default];

  options.modules.desktop.quickshell.noctalia = {
    enable = lib.mkEnableOption "启用 Noctalia Shell";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nixosNoctaliaEnabled;
        message = ''
          Home Manager 的 noctalia 配置已启用，但对应的 NixOS 模块未启用。
          请在你的 NixOS 配置中添加：
            modules.desktop.quickshell.noctalia.enable = true;
        '';
      }
    ];

    programs.noctalia-shell = {
      enable = true;
    };
  };
}
