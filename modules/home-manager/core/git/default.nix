{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.git;

  alias = import ./alias.nix;
in {
  options.modules.git = {
    enable = mkEnableOption "自定义配置模块";

    user = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "Git 用户名";
      };

      email = mkOption {
        type = types.str;
        default = "";
        description = "Git 邮箱";
      };
    };

    signing = {
      enable = mkEnableOption "Git 签名";

      key = mkOption {
        type = types.str;
        default = "";
        description = ''
          签名密钥 ID (GPG: `gpg -k --keyid-format=long`)
        '';
      };
    };

    delta.enable = mkEnableOption "delta 语法高亮 pager";
    tui.enable = mkEnableOption "Git TUI 工具";
  };

  config = mkIf cfg.enable {
    # 清理 `~/.gitconfig`
    home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      rm -f ${config.home.homeDirectory}/.gitconfig
    '';

    programs.git = {
      enable = true;
      lfs.enable = true;

      signing = mkIf cfg.signing.enable {
        key = cfg.signing.key;
        signByDefault = true;
      };

      settings = {
        init.defaultBranch = "main";

        user = {
          name = cfg.user.name;
          email = cfg.user.email;
        };

        push.default = "current"; # 推送当前分支到远程同名分支
        pull.rebase = true; # `git pull` 时默认使用 rebase 而非 merge
        fetch.prune = true;
      };
    };

    # A syntax-highlighting pager for git, diff, grep, and blame output
    programs.delta = mkIf cfg.delta.enable {
      enable = true;
      enableGitIntegration = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
      };
    };

    # Git TUI
    programs.lazygit = mkIf cfg.tui.enable {enable = true;};

    # TODO: git trim
    # TODO: git flow
  };
}
