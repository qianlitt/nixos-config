{
  flake.modules.homeManager.cliTools = {
    lib,
    options,
    pkgs,
    ...
  }: let
    cliPrograms = [
      "bat" # better cat
      "btop" # better top
      "fd" # better find
      "fzf"
      "jq"
      "ripgrep" # better grep
    ];
    cliPkgs = with pkgs; [
      cloc # better wc
      duf # better du
      dust # better du
    ];
  in {
    programs = lib.mkMerge (
      map (
        name:
          lib.mkIf (lib.hasAttrByPath [name] options.programs)
          {${name}.enable = true;}
      )
      cliPrograms
    );

    home.packages = cliPkgs;
  };
}
