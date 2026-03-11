{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.networkd;
  wiredCfg = cfg.wired;

  # 验证静态 IP 配置的完整性
  isValidStaticConfig = wiredCfg.ip != "" && wiredCfg.gateway != "" && length wiredCfg.dns > 0;
in {
  options.modules.nixos.networkd = {
    enable = mkEnableOption "启用 systemd-networkd 网络配置";

    wired = {
      enable = mkEnableOption "启用有线网络配置";

      ip = mkOption {
        type = types.str;
        default = "";
        example = "192.168.1.100/24";
        description = "静态 IPv4 地址（如 192.168.1.100/24）。留空则使用 DHCP";
      };

      gateway = mkOption {
        type = types.str;
        default = "";
        example = "192.168.1.1";
        description = "网关地址。与 ip 配合使用";
      };

      dns = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["1.1.1.1" "8.8.8.8"];
        description = "DNS 服务器地址列表。与 ip 配合使用";
      };
    };
  };

  config = mkIf cfg.enable {
    # 禁用 NetworkManager，使用 systemd-networkd
    networking.networkmanager.enable = false;
    networking.useNetworkd = true;
    systemd.network.enable = true;

    # 启用网络接口自动命名（可预测的接口名称）
    networking.usePredictableInterfaceNames = true;

    # 使用 systemd-resolved 管理 DNS
    services.resolved.enable = true;

    # 有线网络配置
    systemd.network.networks."20-wired" = mkIf wiredCfg.enable {
      matchConfig.Name = "en*"; # 匹配所有以太网接口
      networkConfig = {
        Description = "Wired Ethernet Connection";
        # 自动启动网络连接
        DHCP =
          if isValidStaticConfig
          then "no"
          else "yes";
        LinkLocalAddressing = "no";
      };

      # 静态 IP 配置（仅当配置完整时应用）
      address = mkIf isValidStaticConfig [
        wiredCfg.ip
      ];

      # 网关配置（仅当配置完整时应用）
      gateway = mkIf isValidStaticConfig [
        wiredCfg.gateway
      ];

      # DNS 服务器配置（仅当配置完整时应用）
      dns = mkIf isValidStaticConfig wiredCfg.dns;
    };
  };
}
