{inputs, ...}: {
  flake.overlays.fcitx5 = final: prev: {
    rime-data = prev.symlinkJoin {
      name = "rime-data-custom";
      paths = [
        prev.rime-ice
        inputs.self.packages.${prev.stdenv.hostPlatform.system}.rime-data-tiger
      ];
    };

    fcitx5-rime = prev.fcitx5-rime.override {
      rimeDataPkgs = [final.rime-data];
    };
  };
}
