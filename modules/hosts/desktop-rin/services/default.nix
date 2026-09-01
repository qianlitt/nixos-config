{inputs, ...}: {
  flake.modules.nixos.rin = {
    imports = with inputs.self.modules; [
      nixos."services.printing"
    ];
  };
}
