{inputs, ...}: {
  flake.modules = {
    nixos.profile-cli = {
      imports = with inputs.self.modules.nixos; [
        profile-default

        direnv
        podman

        ai
        gpg
      ];
    };

    darwin.profile-cli = {
      imports = with inputs.self.modules.darwin; [
        profile-default
      ];
    };

    homeManager.profile-cli = {
      imports = with inputs.self.modules.homeManager; [
        profile-default

        cliTools
        eza
        fastfetch
        fish
        git
        nixvim
        shell
        ssh
        starship
        tealdeer
        yazi
        zellij
        zoxide

        ai
        gpg
      ];
    };
  };
}
