final: prev: {
  rime-data = prev.symlinkJoin {
    name = "rime-data-custom";
    paths = [
      prev.rime-ice
      ./rime-data-tiger
    ];
  };

  fcitx5-rime = prev.fcitx5-rime.override {
    rimeDataPkgs = [final.rime-data];
  };
}
