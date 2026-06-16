let
  mkLockedAttrs = builtins.mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });

  mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

  mkExtensionEntry = {
    id,
    pinned ? false,
  }: let
    base = {
      install_url = mkPluginUrl id;
      installation_mode = "force_installed";
    };
  in
    if pinned
    then base // {default_area = "navbar";}
    else base;

  mkExtensionSettings = builtins.mapAttrs (_: entry:
    if builtins.isAttrs entry
    then entry
    else mkExtensionEntry {id = entry;});
in {
  # AutofillAddressEnabled = false; # 禁用地址表单自动填充
  AutofillCreditCardEnabled = false; # 禁用信用卡自动填充
  DisableAppUpdate = true; # 禁用自动更新
  DisableFeedbackCommands = true; # 移除「帮助」菜单中的反馈选项
  DisableFirefoxStudies = true; # 禁止加入实验
  DisablePocket = true; # 完全移除 Pocket 集成
  DisableTelemetry = true; # 关闭所有遥测数据上报
  DontCheckDefaultBrowser = true; # 不检查是否是默认浏览器
  NoDefaultBookmarks = true; # 不创建 Mozilla 推广书签
  OfferToSaveLogins = false; # 关闭「是否保存密码」提示
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
  };
  ExtensionSettings = mkExtensionSettings {
    # 去广告 & 隐私保护
    # UBlock Origin
    "uBlock0@raymondhill.net" = mkExtensionEntry {
      id = "ublock-origin";
      pinned = true;
    };
    "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls"; # 移除跟踪元素
    "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes"; # 避免 CDN 跟踪
    "@searchengineadremover" = "searchengineadremover"; # 移除搜索引擎广告
    "@ublacklist" = "ublacklist"; # 在 Google 的搜索结果中屏蔽特定的网站

    # Youtube
    "sponsorBlocker@ajay.app" = "sponsorblock"; # 跳过 YouTube 赞助商广告
    "{4590d8b8-3569-46e3-a571-cabfbaeab2c1}" = "no-youtube-shorts"; # 移除 YouTube 短视频
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes"; # 显示 YouTube 点赞和踩数
    "{fef652df-dd80-450e-b64a-567abeb3aa4b}" = "youtube-cards"; # 移除 YouTube 播放结束后的推荐卡片

    # GitHub
    "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons"; # 为 github 文件添加图标
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
    "github-no-more@ihatereality.space" = "github-no-more"; # 移除 GitHub "Load more"、"Load diff" 按钮
    "github-repository-size@pranavmangal" = "gh-repo-size"; # 显示 GitHub 仓库大小
    "isometric-contributions@jasonlong.me" = "github-isometric-contributions"; # GitHub 贡献图

    # Others
    "firefox-extension@steamdb.info" = "steam-database";
    "firefox@tampermonkey.net" = "tampermonkey"; # 油猴
    "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}" = "kiss-translator"; # 简约翻译
    "addon@celeus.cn" = "bewlycat"; # BewlyCat - BiliBili 优化
    # Bitwarden - 密码管理器
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExtensionEntry {
      id = "bitwarden-password-manager";
      pinned = true;
    };
    "{74e326aa-c645-4495-9287-b6febc5565a7}" = "competitive-companion"; # 竞赛题解析
    # Obsidian Web Clipper
    "clipper@obsidian.md" = mkExtensionEntry {
      id = "web-clipper-obsidian";
      pinned = true;
    };
  };
  Preferences = mkLockedAttrs {
    "browser.aboutConfig.showWarning" = false; # 关闭 about:config 页面的警告提示
    "browser.tabs.warnOnClose" = false; # 关闭多个标签页时不弹确认提示
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = true; # 视频上显示画中画切换按钮
    "browser.tabs.hoverPreview.enabled" = true; # 鼠标悬停标签页时显示预览缩略图
    "browser.newtabpage.activity-stream.feeds.topsites" = false; # 新标签页不显示常用网站
    "browser.topsites.contile.enabled" = false; # 禁用新标签页的赞助商/推荐内容
    "browser.translations.enable" = false; # 禁用内置网页翻译功能

    "privacy.resistFingerprinting" = true; # 对抗浏览器指纹追踪
    "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true; # 使用 SipHash 算法对 Canvas 指纹进行随机化
    "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true; # Canvas 指纹每天重置
    "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true; # 隐私模式下 Canvas 指纹也每日重置
    "privacy.resistFingerprinting.block_mozAddonManager" = true; # 阻止网站通过 mozAddonManager 检测已安装扩展
    "privacy.spoof_english" = 1; # 向网站报告英语语言偏好，掩盖真实语言

    "privacy.firstparty.isolate" = true; # 不同网站的 Cookie、缓存、存储完全隔离
    "network.cookie.cookieBehavior" = 5; # 绝所有第三方 Cookie，并隔离第一方 Cookie
    "dom.battery.enabled" = false; # 禁用 Battery API

    "gfx.webrender.all" = true; # GPU 硬件加速
    "network.http.http3.enabled" = true; # 启用 HTTP/3 (QUIC) 协议
    "network.socket.ip_addr_any.disabled" = true; # 禁用 0.0.0.0 / :: 绑定，防止某些本地服务暴露在所有网络接口上
  };
}
