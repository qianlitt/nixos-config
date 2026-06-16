{
  flake.overlays.openldap = _final: prev: {
    openldap = prev.openldap.overrideAttrs (_: {
      doCheck = false;
    });
  };
}
