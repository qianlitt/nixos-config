# default settings needed for all darwinConfigurations
{
  flake.modules.darwin.system-minimal = {
    nixpkgs.config.allowUnfree = true;

    system.stateVersion = 6;

    # Custom settings written to /etc/nix/nix.custom.conf
    determinateNix.customSettings = {
      # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
      eval-cores = 0;

      # Disable global registry
      flake-registry = "";

      lazy-trees = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      extra-experimental-features = [
        "build-time-fetch-tree" # Enables build-time flake inputs
        "parallel-eval" # Enables parallel evaluation
      ];
    };
  };
}
