{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.postgresql;
in {
  options.modules.nixos.postgresql = {
    enable = lib.mkEnableOption "启用 PostgreSQL 服务";

    # 基础配置
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql;
      example = pkgs.postgresql_17;
      description = "PostgreSQL 包";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5432;
      description = "PostgreSQL 监听端口";
    };

    enableTCPIP = lib.mkEnableOption "启用 TCP/IP 监听";

    authentication = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "PostgreSQL 认证配置 (pg_hba.conf)";
    };

    # 数据库和用户管理 - 直接透传，不做类型检查，由下层模块处理
    ensureDatabases = lib.mkOption {
      default = [];
      description = "确保指定的数据库存在";
    };

    ensureUsers = lib.mkOption {
      default = [];
      description = "确保指定的用户存在";
    };

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["postgis" "pg_repack"];
      description = "要安装的扩展名称列表";
    };

    # 额外配置
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "额外的 PostgreSQL 配置 (postgresql.conf)";
    };

    # 备份配置
    backup = {
      enable = lib.mkEnableOption "启用 PostgreSQL 备份";

      location = lib.mkOption {
        type = lib.types.path;
        default = "/var/backup/postgresql";
        description = "备份存储位置";
      };

      backupAll = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "是否备份所有数据库";
      };

      databases = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "要备份的数据库列表（与 backupAll 互斥）";
      };

      compression = lib.mkOption {
        type = lib.types.enum ["none" "gzip" "zstd"];
        default = "gzip";
        description = "压缩类型";
      };

      compressionLevel = lib.mkOption {
        type = lib.types.int;
        default = 6;
        description = "压缩级别";
      };

      startAt = lib.mkOption {
        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
        default = "*-*-* 01:15:00";
        description = "备份时间（systemd.time 格式）";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      inherit (cfg) package enableTCPIP authentication;
      ensureDatabases = cfg.ensureDatabases;
      ensureUsers = cfg.ensureUsers;
      extensions = ps: map (ext: ps.${ext}) cfg.extensions;
      settings =
        cfg.settings
        // {
          port = cfg.port;
        };
    };

    # 备份配置
    services.postgresqlBackup = lib.mkIf cfg.backup.enable {
      enable = true;
      inherit (cfg.backup) location backupAll databases compression compressionLevel startAt;
    };

    # 创建备份目录
    systemd.tmpfiles.rules = lib.mkIf cfg.backup.enable [
      "d '${cfg.backup.location}' 0755 postgres postgres - -"
    ];

    # 断言
    assertions = [
      {
        assertion = cfg.backup.enable -> (cfg.backup.backupAll || (builtins.length cfg.backup.databases > 0));
        message = "如果启用了 PostgreSQL 备份且 backupAll 为 false，则必须指定 databases。";
      }
    ];

    # 防火墙配置（如果启用 TCPIP）
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.enableTCPIP [cfg.port];
  };
}
