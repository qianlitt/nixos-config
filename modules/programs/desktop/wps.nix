{
  flake.modules.homeManager.wps = {pkgs, ...}: let
    wpsWrapped = pkgs.symlinkJoin {
      name = "wpsoffice-cn-wrapped";
      paths = [pkgs.wpsoffice-cn];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        for bin in wps wpp et wpspdf; do
          [ -e "$out/bin/$bin" ] && wrapProgram "$out/bin/$bin" \
            --set QT_FONT_DPI "154" \
            --set QT_IM_MODULE "fcitx5" \
            --set XMODIFIERS "@im=fcitx"
        done
      '';
    };
  in {
    home.packages = [
      wpsWrapped
      pkgs.nur.repos.rewine.ttf-ms-win10
    ];
  };
}
