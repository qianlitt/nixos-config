{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.customSsh;
in {
  options.services.customSsh = {
    enable = mkEnableOption "启用自定义 SSH 配置";

    ports = mkOption {
      type = types.listOf types.port;
      default = [22];
      description = "SSH 服务监听的端口";
    };

    allowRoot = mkOption {
      type = types.bool;
      default = false;
      description = "是否允许 root 用户通过 ssh 登录";
    };

    allowPassword = mkOption {
      type = types.bool;
      default = true;
      description = "是否允许普通用户使用密码登录 ssh";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = mkDefault cfg.ports;
      openFirewall = true;
      settings = {
        PermitRootLogin =
          if cfg.allowRoot
          then "yes"
          else "no";
        PasswordAuthentication = cfg.allowPassword;
      };
    };
  };
}
