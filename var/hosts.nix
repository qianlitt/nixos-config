/**
* hosts - 主机配置
*
* type: server | desktop
*   - server: 服务器，通常不配置图形界面和显示器
*   - desktop: 桌面工作站，启用图形环境及外设配置
*
* tag: 功能标签列表，用于条件启用特定模块或配置
*/
{
  frieren = {
    type = "server";
  };

  rin = {
    type = "desktop";
    tag = [
      "ai" # 启用 AI 模块
      "gpg" # 启用 gpg 模块，导入 gpg 密钥
    ];

    monitors = {
      "eDP-2" = {
        width = 2560;
        height = 1600;
        refreshRate = 60.002;
        scale = 1.5;
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-3" = {
        primaryMonitor = true; # 设为主显示器
        width = 3840;
        height = 2560;
        refreshRate = 59.984;
        scale = 1.5;
        position = {
          x = 1707;
          y = -300;
        };
      };
    };
  };
}
