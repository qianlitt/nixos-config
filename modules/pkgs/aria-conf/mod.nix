{
  perSystem = {pkgs, ...}: {
    packages.aria-conf = pkgs.callPackage ./_package.nix {};
  };
}
