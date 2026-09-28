{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.rime-data-tiger = pkgs.callPackage ./_package.nix {
      inherit (config.packages) huma-rime;
    };
  };
}
