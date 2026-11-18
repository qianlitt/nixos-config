{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = [
      inputs.self.lib.modules.nixos.profile-cli
      # ...
    ];

    # ...
  };
}
