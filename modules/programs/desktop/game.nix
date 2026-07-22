{inputs, ...}: {
  flake-file.inputs = {
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.game = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.desktop.game;
  in {
    imports = [inputs.aagl.nixosModules.default];

    options.modules.desktop.game = {
      enable = lib.mkEnableOption "安装游戏";
    };

    config = lib.mkIf cfg.enable {
      # 缓存配置
      nix.settings = {
        substituters = lib.mkOrder 700 ["https://ezkea.cachix.org"];
        trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
      };

      programs = {
        steam = {
          enable = true;
          gamescopeSession.enable = true;
          protontricks.enable = true;
        };

        # 启用 gamemode 以提升性能
        gamemode.enable = true;

        honkers-railway-launcher.enable = true; # 崩坏: 星穹铁道
      };

      # 解决 Steam 无法启动的问题
      # https://wiki.nixos.org/wiki/Steam#Steam_fails_to_start._What_do_I_do?
      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;

      # 解决 Lutris 安装过程中 openldap 编译失败的问题
      nixpkgs.overlays = [
        inputs.self.overlays.openldap
      ];
    };
  };

  flake.modules.homeManager.game = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.desktop.game;
  in {
    options.modules.desktop.game = {
      enable = lib.mkEnableOption "安装游戏";
    };

    config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        # 帧率、温度、负载显示
        # https://github.com/flightlessmango/MangoHud
        mangohud

        # Proton 管理器
        protonplus
        # Wine 环境下快速安装各种 Windows 组件
        winetricks
        # Windows 游戏统一启动器
        # https://github.com/Open-Wine-Components/umu-launcher
        umu-launcher

        # 二进制文件编辑器
        bbe
      ];

      # Lutris
      programs.lutris = {
        enable = true;
        winePackages = with pkgs; [
          wineWow64Packages.full
        ];
        extraPackages = with pkgs; [
          winetricks
          gamescope
          gamemode
          mangohud
          umu-launcher
        ];
      };
    };
  };
}
