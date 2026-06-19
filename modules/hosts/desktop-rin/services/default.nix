{inputs, ...}: {
  flake.modules.nixos.rin = {config, ...}: {
    imports = with inputs.self.modules; [
      nixos."services.gitlab-runner"
    ];

    modules = {
      cli.podman = {
        enable = true;
        quadlet.enable = true;
      };
    };

    sops.secrets = {
      "services/gitlab-runner/default" = {};
    };

    # Runner 定义
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
  };
}
