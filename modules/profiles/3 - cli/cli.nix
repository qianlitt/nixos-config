{inputs, ...}: {
  flake.modules = {
    nixos.profile-cli = {
      imports = with inputs.self.lib.modules.nixos; [
        profile-default

        direnv
        podman

        ai
        gpg
      ];
    };

    darwin.profile-cli = {
      imports = with inputs.self.lib.modules.darwin; [
        profile-default
      ];
    };

    homeManager.profile-cli = {
      imports = with inputs.self.lib.modules;
      with inputs.self.lib.modules.homeManager; [
        profile-default

        cliTools
        eza
        fastfetch
        fish
        homeManager."git.min"
        homeManager."nixvim.base"
        shell
        ssh
        starship
        tealdeer
        yazi
        zellij
        zoxide
      ];
    };
  };
}
