{inputs, ...}: {
  flake.modules.nixos.rin = {config, ...}: {
    imports = with inputs.self.modules; [
      nixos."services.gitlab-runner"
    ];

    modules.cli.podman = {
      enable = true;
      quadlet.enable = true;
    };

    users.groups.github-runner = {};
    users.users.github-runner = {
      isSystemUser = true;
      group = "github-runner";
    };
    nix.settings.trusted-users = ["github-runner"];

    sops.secrets = {
      "services/gitlab-runner/default" = {};
      "services/github-runner/nixos-config" = {owner = "github-runner";};
    };

    # GitLab Runner
    services.gitlab-runner.services = {
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
    services.github-runners."nixos-config" = {
      enable = true;
      url = "https://github.com/qianlitt/nixos-config";
      tokenFile = config.sops.secrets."services/github-runner/nixos-config".path;
      user = "github-runner";
      extraLabels = ["nix"]; # workflow 用 runs-on: [self-hosted, nix]
    };
  };
}
