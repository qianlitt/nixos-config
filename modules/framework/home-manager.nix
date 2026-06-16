# home-manager: 使用 Nix 管理用户配置
# https://github.com/nix-community/home-manager
{inputs, ...}: let
  home-manager-config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
in {
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };

  flake.modules.darwin.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      home-manager-config
    ];
  };
}
