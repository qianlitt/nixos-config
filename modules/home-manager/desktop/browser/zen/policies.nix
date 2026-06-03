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
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  DisableAppUpdate = true;
  DisableFeedbackCommands = true;
  DisableFirefoxStudies = true;
  DisablePocket = true; # save webs for later reading
  DisableTelemetry = true;
  DontCheckDefaultBrowser = true;
  NoDefaultBookmarks = true;
  OfferToSaveLogins = false;
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
    "browser.aboutConfig.showWarning" = false;
    "browser.tabs.warnOnClose" = false;
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
    "browser.tabs.hoverPreview.enabled" = true;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.topsites.contile.enabled" = false;
    "browser.translations.enable" = false;

    "privacy.resistFingerprinting" = true;
    "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
    "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
    "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    "privacy.spoof_english" = 1;

    "privacy.firstparty.isolate" = true;
    "network.cookie.cookieBehavior" = 5;
    "dom.battery.enabled" = false;

    "gfx.webrender.all" = true;
    "network.http.http3.enabled" = true;
    "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
  };
}
