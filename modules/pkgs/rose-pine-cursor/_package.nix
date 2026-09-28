{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-cursor";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/rose-pine/cursor/releases/download/v${version}/BreezeX-RosePine-Linux.tar.xz";
    hash = "sha256-szDVnOjg5GAgn2OKl853K3jZ5rVsz2PIpQ6dlBKJoa8=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -R BreezeX-RosePine-Linux $out/share/icons/rose-pine-cursor
    runHook postInstall
  '';

  meta = with lib; {
    description = "Soho vibes for Cursors";
    downloadPage = "https://github.com/rose-pine/cursor/releases";
    homepage = "https://rosepinetheme.com/";
    license = licenses.gpl3;
  };
}
