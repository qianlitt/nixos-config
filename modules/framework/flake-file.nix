# flake-file
# Options: https://flake-file.denful.dev/reference/options/#style-options
{inputs, ...}: {
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "A flake for NixOS configuration";
    inputs = {
      flake-file.url = "github:vic/flake-file";
    };
    outputs = ''
      inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules)
    '';

    formatter = pkgs: pkgs.alejandra;
  };
}
