{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.rime-data-tiger = pkgs.runCommand "huma-rime-rime-data" {} ''
      mkdir -p $out/share/rime-data
      cp -r ${config.packages.huma-rime}/. $out/share/rime-data/
    '';
  };
}
