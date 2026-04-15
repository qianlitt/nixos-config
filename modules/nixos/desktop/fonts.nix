{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      maple-mono.NF-CN-unhinted
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      lxgw-wenkai
    ];
    fontconfig = {
      enable = true;

      # HiDPI 优化
      hinting = {
        enable = false;
        style = "none";
      };
      antialias = true;
      subpixel = {
        rgba = "rgb";
        lcdfilter = "none";
      };

      useEmbeddedBitmaps = true; # fix firefox emoji rendering

      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Maple Mono NF CN"
          "JetBrainsMono Nerd Font"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Sans"
        ];
        serif = [
          "Noto Sans CJK SC"
          "Noto Serif"
        ];
      };
      localConf = ''
        <!-- 中文语言回退 -->
        <match>
          <test name="lang" compare="contains"><string>zh</string></test>
          <test name="family"><string>monospace</string></test>
          <edit name="family" mode="prepend"><string>Maple Mono NF CN</string></edit>
        </match>

        <!-- Emoji 回退 -->
        <match>
          <test name="family"><string>monospace</string></test>
          <edit name="family" mode="append" binding="weak">
            <string>Symbols Nerd Font</string>
          </edit>
        </match>
      '';
    };
  };
}
