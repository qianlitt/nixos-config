{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.cli.quadlet;
in {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];

  options.modules.cli.quadlet = {
    enable = lib.mkEnableOption "启用 Quadlet，Podman 容器管理器";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = {
      enable = true;

      autoUpdate = {
        enable = true;
      };
    };
  };
}
