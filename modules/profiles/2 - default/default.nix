# import all essential nix-tools which are used in all modules of a specific class
{inputs, ...}: {
  flake.modules = {
    nixos.profile-default = {
      imports = with inputs.self.lib.modules.nixos;
        [
          profile-minimal

          home-manager
        ]
        ++ [inputs.self.lib.modules.generic.systemConstants];
    };

    darwin.profile-default = {
      imports = with inputs.self.lib.modules.darwin;
        [
          profile-minimal

          home-manager
        ]
        ++ [inputs.self.lib.modules.generic.systemConstants];
    };

    homeManager.profile-default = {
      imports = with inputs.self.lib.modules.homeManager;
        [
          profile-minimal
        ]
        ++ [inputs.self.lib.modules.generic.systemConstants];
    };
  };
}
