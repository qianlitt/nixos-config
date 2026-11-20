{inputs, ...}: {
  flake.modules.nixos.rin = {config, ...}: {
    imports = with inputs.self.lib.modules; [
      nixos."services.gitlab-runner"
    ];

    users.groups.github-runner = {};
    users.users.github-runner = {
      isSystemUser = true;
      group = "github-runner";
    };
    nix.settings.trusted-users = ["github-runner"];

    sops.secrets = {
      "services/gitlab-runner/default" = {
        sopsFile = "${inputs.self.inputs.secrets}/hosts/rin.yaml";
      };
      "services/github-runner/nixos-config" = {
        owner = "github-runner";
        sopsFile = "${inputs.self.inputs.secrets}/hosts/rin.yaml";
      };
      "services/gitea-runner/global" = {
        sopsFile = "${inputs.self.inputs.secrets}/hosts/rin.yaml";
      };
      "services/gitea-runner/personal" = {
        sopsFile = "${inputs.self.inputs.secrets}/hosts/rin.yaml";
      };
    };

    services = {
      # GitLab Runner
      gitlab-runner.services = {
        default = {
          authenticationTokenConfigFile = config.sops.secrets."services/gitlab-runner/default".path;

          executor = "docker";
          dockerImage = "alpine:latest";
          description = "podman runner";

          dockerVolumes = [
            "/run/podman/podman.sock:/var/run/docker.sock"
          ];

          dockerPullPolicy = "if-not-present";
        };
      };

      # GitHub Runner
      github-runners."nixos-config" = {
        enable = true;
        url = "https://github.com/qianlitt/nixos-config";
        tokenFile = config.sops.secrets."services/github-runner/nixos-config".path;
        user = "github-runner";
        extraLabels = ["nix"]; # workflow 用 runs-on: [self-hosted, nix]
      };

      # Gitea Runner
      gitea-actions-runner.instances = {
        "global-docker" = {
          enable = true;

          name = "rin-docker";
          url = "https://git.lan.1806016.xyz";

          tokenFile = config.sops.secrets."services/gitea-runner/global".path;

          labels = [
            "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
          ];

          settings = {
            runner = {
              capacity = 2;
              timeout = "3h";
            };
          };
        };

        "personal-host" = {
          enable = true;

          name = "rin-host";
          url = "https://git.lan.1806016.xyz";

          tokenFile = config.sops.secrets."services/gitea-runner/personal".path;

          labels = [
            "nixos:host"
          ];

          settings = {
            runner = {
              capacity = 1;
              timeout = "3h";
            };
          };
        };
      };
    };
  };
}
