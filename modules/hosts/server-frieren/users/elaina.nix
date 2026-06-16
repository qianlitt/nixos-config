{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = with inputs.self.modules.nixos;
    with inputs.self.factory; [
      elaina
    ];

    home-manager.users.elaina = {
      imports = [];

      modules = {
        cli = {
          nixvim = {
            enable = true;
          };
        };
      };
    };
  };
}
