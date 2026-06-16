{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = [
      inputs.self.modules.nixos.profile-cli
      # ...
    ];

    # ...
  };
}
