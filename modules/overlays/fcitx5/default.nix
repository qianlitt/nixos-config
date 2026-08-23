{
  flake.overlays.fcitx5 = final: prev: let
    huma-rime = prev.fetchFromGitHub {
      owner = "zhhmn";
      repo = "huma-rime";
      rev = "fafb978e739fe41d91e02f35290f81c42b5f6162";
      hash = "sha256-ArWf61NsZksOC51daXz8rW8PVI7yOKlWgQBtTEBmdpU=";
    };

    rime-data-tiger = prev.runCommand "huma-rime-rime-data" {} ''
      mkdir -p $out/share/rime-data
      cp -r ${huma-rime}/. $out/share/rime-data/
    '';
  in {
    rime-data = prev.symlinkJoin {
      name = "rime-data-custom";
      paths = [
        prev.rime-ice
        rime-data-tiger
      ];
    };

    fcitx5-rime = prev.fcitx5-rime.override {
      rimeDataPkgs = [final.rime-data];
    };
  };
}
