{
  perSystem = {pkgs, ...}: {
    packages.rose-pine-cursor = pkgs.callPackage ./_package.nix {};
  };
}
