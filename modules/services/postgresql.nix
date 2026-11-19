{
  flake.modules.nixos."services.postgresql" = {
    services.postgresql.enable = true;

    # 备份配置
    services.postgresqlBackup.enable = true;
  };
}
