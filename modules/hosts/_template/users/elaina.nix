{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = with inputs.self.modules.nixos;
    with inputs.self.factory; [
      elaina # username
    ];

    # ...

    home-manager.users.elaina = {
      imports = [
        # ...
      ];

      # ...
    };
  };
}
