{
  flake.modules.homeManager.git = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.cli.git;

    alias = import ./_alias.nix;
  in {
    options.modules.cli.git = {
      enable = lib.mkEnableOption "自定义配置模块";

      user = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Git 用户名";
        };

        email = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Git 邮箱";
        };
      };

      signing = {
        enable = lib.mkEnableOption "Git 签名";

        key = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = ''
            签名密钥 ID (GPG: `gpg -k --keyid-format=long`)
          '';
        };
      };

      gh.enable = lib.mkEnableOption "GitHub CLI 工具";
      delta.enable = lib.mkEnableOption "delta 语法高亮 pager";
      tui.enable = lib.mkEnableOption "Git TUI 工具";
    };

    config = lib.mkIf cfg.enable {
      # 清理 `~/.gitconfig`
      home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        rm -f ${config.home.homeDirectory}/.gitconfig
      '';

      programs.git = {
        enable = true;
        lfs.enable = true;

        signing = lib.mkIf cfg.signing.enable {
          key = cfg.signing.key;
          signByDefault = true;
        };

        settings = {
          init.defaultBranch = "main";

          user = {
            name = cfg.user.name;
            email = cfg.user.email;
          };

          inherit alias;

          push.default = "current"; # 推送当前分支到远程同名分支
          pull.rebase = true; # `git pull` 时默认使用 rebase 而非 merge
          fetch.prune = true;
        };
      };

      programs = {
        # GitHub CLI
        gh.enable = cfg.gh.enable;

        # A syntax-highlighting pager for git, diff, grep, and blame output
        delta = lib.mkIf cfg.delta.enable {
          enable = true;
          enableGitIntegration = true;
          options = {
            diff-so-fancy = true;
            line-numbers = true;
            true-color = "always";
          };
        };

        # Git TUI
        lazygit = lib.mkIf cfg.tui.enable {enable = true;};
      };

      # TODO: git trim
      # TODO: git flow
    };
  };
}
