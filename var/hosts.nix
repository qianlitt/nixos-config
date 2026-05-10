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
  };
}
