{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.modules.fcitx5;

  nixosFcitx5Enabled = osConfig.modules.fcitx5.enable or false;
in {
  options.modules.fcitx5 = {
    enable = lib.mkEnableOption "启用 Fcitx5 输入法框架";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nixosFcitx5Enabled;
        message = ''
          Home Manager 的 fcitx5 配置已启用，但对应的 NixOS 模块未启用。
          请在你的 NixOS 配置中添加：
            modules.modules.fcitx5.enable = true;
        '';
      }
    ];

    # rime 配置
    home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
      patch:
        __include: rime_ice_suggestion:/
        schema_list:
          - schema: tiger
          - schema: rime_ice
          - schema: double_pinyin_flypy
    '';
  };
}
