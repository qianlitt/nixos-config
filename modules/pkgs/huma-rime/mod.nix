{
  perSystem = {pkgs, ...}: {
    packages.huma-rime = pkgs.callPackage ./_package.nix {};
  };
}
