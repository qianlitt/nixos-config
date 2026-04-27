{
  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true; # 启用自动更新
    settings = {
      display = {
        use_pager = true;
        compact = false;
        show_title = true;
      };
      search = {
        languages = ["zh" "en"];
      };
      updates = {
        auto_update = true;
        download_languages = ["zh" "en"];
      };
    };
  };
}
