{inputs, ...}: {
  flake = {
    modules.homeManager = {
      "git.min" = {
        config,
        lib,
        ...
      }: let
        alias = import ./_alias.nix;
      in {
        # 清理 `~/.gitconfig`
        home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
          rm -f ${config.home.homeDirectory}/.gitconfig
        '';

        programs.git = {
          enable = true;
          lfs.enable = true;

          settings = {
            init.defaultBranch = "main";

            inherit alias;

            push.default = "current"; # 推送当前分支到远程同名分支
            pull.rebase = true; # `git pull` 时默认使用 rebase 而非 merge
            fetch.prune = true;
          };
        };
      };

      "git.full" = {pkgs, ...}: {
        imports = [inputs.self.lib.modules.homeManager."git.min"];

        programs = {
          # GitHub CLI
          gh.enable = true;

          # # A syntax-highlighting pager for git, diff, grep, and blame output
          # delta = {
          #   enable = true;
          #   enableGitIntegration = true;
          #   options = {
          #     diff-so-fancy = true;
          #     line-numbers = true;
          #     true-color = "always";
          #   };
          # };

          # Git TUI
          lazygit = {
            enable = true;

            settings = {
              git.overrideGpg = true;
            };
          };
        };

        home.packages = with pkgs; [
          git-filter-repo
          git-trim
          git-town

          hunk
        ];
      };
    };

    factory = {
      gitSigningKey = {signingKey}: {
        programs.git.signing = {
          signByDefault = true;
          key = signingKey;
        };
      };

      gitUser = {
        name,
        email,
      }: {
        programs.git.settings.user = {
          inherit name email;
        };
      };
    };
  };
}
