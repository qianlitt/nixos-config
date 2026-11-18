{inputs, ...}: {
  flake.modules.nixos.rin = {
    imports = with inputs.self.lib.modules; [
      nixos."services.printing"
    ];
  };
}
