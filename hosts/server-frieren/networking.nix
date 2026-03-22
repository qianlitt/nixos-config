/*
* 这个配置文件主要 qBittorrent 下载器分流使用。
*
* - 主路由和 secondIp 用于下载流量（不通过旁路由进行代理）
* - 旁路由用于其他流量
*/
let
  mainRouter = "192.168.1.1";
  sideRouter = "192.168.1.200";

  mainIp = "192.168.1.102";
  secondIp = "192.168.1.103";
  prefixLength = 24;
in {
  # 禁用 NetworkManager，使用 systemd-networkd
  networking.networkmanager.enable = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # 定义自定义路由表
  networking.iproute2 = {
    enable = true;
    rttablesExtraConfig = ''
      100   custom
    '';
  };

  # 配置网络接口、地址、路由和策略路由规则
  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "en*";

    networkConfig = {
      Description = "Wired Ethernet Connection";
      DHCP = "no";
      LinkLocalAddressing = "no";
    };

    address = [
      "${mainIp}/${toString prefixLength}"
      "${secondIp}/${toString prefixLength}"
    ];

    dns = [
      sideRouter
      mainRouter
    ];

    # 路由：
    # - 第一条不指定 Table，默认加入 main 表（旁路由网关）
    # - 第二条指定 Table = "custom"，仅用于 custom 表
    routes = [
      {Gateway = sideRouter;} # main 表默认路由
      {
        Gateway = mainRouter;
        Table = "100";
      }
    ];

    # 策略路由规则：让 secondIp 的流量走 custom 表
    routingPolicyRules = [
      {
        From = "${secondIp}";
        Table = "100";
      }
    ];
  };
}
