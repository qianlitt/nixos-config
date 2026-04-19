{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=AcceleratedVideoEncoder"
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
    ];
    extensions = [
      # 广告拦截 & 隐私保护
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite - 广告拦截器
      {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";} # Decentraleyes - 避免 CDN 跟踪
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # SponsorBlock for YouTube - 跳过赞助商广告
      {id = "pncfbmialoiaghdehhbnbhkkgmjanfhe";} # uBlacklist - 屏蔽特定网站的搜索结果

      # GitHub
      {id = "ficfmibkjjnpogdcfhfokmihanoldbfe";} # File Icons for GitHub and GitLab - GitHub 文件图标
      {id = "hlepfoohegkhhmjieoechaddaejaokhf";} # Refined GitHub - GitHub 界面增强

      # Tools
      {id = "bdiifdefkgmcblbcghdlonllpjhhjgof";} # 简约翻译
      {id = "gcalenpjmijncebpfijmoaglllgpjagf";} # Tampermonkey BETA
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden - 密码管理器
      {id = "lildghglkgcoanblbmenbefhnhifghjj";} # BewlyBewly! Ave Mujica - BiliBili 增强
      {id = "cjnmckjndlpiamhfimnnjmnckgghkjbl";} # Competitive Companion
      {id = "cnjifjpddelmedmihgijeibhnjfabmlf";} # Obsidian Web Clipper
    ];
  };
}
