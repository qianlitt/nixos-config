{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = with inputs.self.lib.modules.nixos;
    with inputs.self.factory; [
      elaina
    ];

    home-manager.users.elaina = {
      imports = [];
    };
  };
}
