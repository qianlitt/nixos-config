{
  flake.modules.nixos."services.gitlab" = {lib, ...}: {
    services.gitlab = {
      enable = true;

      https = lib.mkDefault true;

      # SMTP 邮件发送
      smtp = lib.mkDefault {
        enable = true;
        address = "localhost";
        port = 25;
      };

      # 备份
      backup = lib.mkDefault {
        startAt = "03:00";
        keepTime = 48; # 保留 48 小时
      };

      # registry
      registry = lib.mkDefault {
        enable = true;
        certFile = "/var/gitlab/cert/registry.crt";
        keyFile = "/var/gitlab/cert/registry.key";
      };
    };
  };
}
