{
  flake.modules.nixos."services.ssh" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.ssh;
  in {
    options.modules.services.ssh = {
      enable = lib.mkEnableOption "启用 OpeSSH 服务配置";

      ports = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        default = [22];
        description = "SSH 服务监听的端口";
      };

      allowRoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "是否允许 root 用户通过 ssh 登录";
      };

      allowPassword = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "是否允许普通用户使用密码登录 ssh";
      };
    };

    config = lib.mkIf cfg.enable {
      services.openssh = {
        enable = true;
        ports = lib.mkDefault cfg.ports;
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
  };
}
