{
  flake.modules.nixos."services.calibre" = {
    config,
    lib,
    ...
  }: {
    services.calibre-web = {
      enable = true;

      openFirewall = lib.mkDefault true;
      listen = lib.mkDefault {
        ip = "0.0.0.0";
        port = 8083;
      };

      options = lib.mkDefault {
        calibreLibrary = "/var/lib/calibre-library";

        enableBookUploading = true; # 允许通过 Web 界面上传书籍
        enableBookConversion = true; # 启用 Calibre 的 ebook-convert 转换
        enableKepubify = true; # 启用 Kepubify（Kobo 格式转换）
      };
    };

    systemd.tmpfiles.settings."10-calibre-library" = {
      ${config.services.calibre-web.options.calibreLibrary}.d = {
        user = config.services.calibre-web.user;
        group = config.services.calibre-web.group;
        mode = "0755";
      };
    };
  };
}
