{
  lib,
  mylib,
  myvar,
  hostConfig,
  ...
}: let
  hasTag = tag: lib.elem tag (hostConfig.tag or []);
in {
  imports = map mylib.root [
    "modules/home-manager/cli"
  ];

  modules.cli = {
    git = {
      enable = true;
      user = {
        name = myvar.git.user.name;
        email = myvar.git.user.email;
      };
      signing = {
        enable = true;
        key = myvar.git.signingKey;
      };
      gh.enable = true;
      tui.enable = true;
    };

    gpg = lib.mkIf (hasTag "gpg") {
      enable = true;
      sshKeys = [myvar.gpg.keygrip];
      importKey = {
        enable = true;
        fingerprint = myvar.gpg.fingerprint;
      };
    };

    ai.enable = lib.mkIf (hasTag "ai") true;

    nixvim = {
      enable = true;

      completion.enable = lib.mkIf (hasTag "develop") true;
      lsp.enable = lib.mkIf (hasTag "develop") true;
      format.enable = lib.mkIf (hasTag "develop") true;
      lint.enable = lib.mkIf (hasTag "develop") true;
      treesitter.enable = lib.mkIf (hasTag "develop") true;
    };
  };
}
