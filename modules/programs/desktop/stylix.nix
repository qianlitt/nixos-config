# Stylix NixOS 模块配置
#
# 此处包含了 Stylix 的主题、光标和字体等基础配置，这些配置默认将传递给 home-manager 模块。
{inputs, ...}: {
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.stylix = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.desktop.stylix;

    # 色彩方案: https://tinted-theming.github.io/tinted-gallery/
    themeName = "catppuccin-mocha";

    # 本仓库自打包的派生，见 modules/pkgs/
    ps = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    options.modules.desktop.stylix = {
      enable = lib.mkEnableOption "启用 stylix";
    };

    config = lib.mkIf cfg.enable {
      stylix = {
        enable = true;

        autoEnable = true;

        # Theme
        polarity = "dark"; # 强制深色主题
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";
        cursor = {
          name = "rose-pine-cursor";
          package = ps.rose-pine-cursor;
          size = 20;
        };
        fonts = {
          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
          monospace = {
            name = "Maple Mono NF CN";
            package = pkgs.maple-mono.NF-CN-unhinted;
          };
          sansSerif = {
            name = "Noto Sans CJK SC";
            package = pkgs.noto-fonts-cjk-sans;
          };
          serif = {
            name = "Noto Sans CJK SC";
            package = pkgs.noto-fonts-cjk-sans;
          };

          sizes = {
            applications = 12;
            desktop = 10;
            terminal = 12;
          };
        };
        opacity = {
          # 不透明度设置
          applications = 0.95;
          desktop = 1.0;
          terminal = 0.9;
        };
      };
    };
  };

  flake.modules.homeManager.stylix = {
    osConfig,
    lib,
    ...
  }: let
    nixosStylixEnabled = osConfig.modules.desktop.stylix.enable or false;
  in
    lib.optionalAttrs nixosStylixEnabled {
      stylix.targets = {
        nixvim.colors.enable = false;
        vscode.enable = false; # VSCode 主题由插件提供
        noctalia-shell.enable = false;
        hyprland.colors.enable = false; # BUG: 当前 stylix 不能正确配置 decoration
        zen-browser.enable = false;
      };
    };
}
