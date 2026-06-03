{pkgs, ...}: {
  force = true;
  default = "google";
  privateDefault = "google";
  engines = let
    nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  in {
    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = nixSnowflakeIcon;
      definedAliases = ["np"];
    };
    "Nix Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = nixSnowflakeIcon;
      definedAliases = ["nop"];
    };
    "Home Manager Options" = {
      urls = [
        {
          template = "https://home-manager-options.extranix.com/";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
            {
              name = "release";
              value = "master"; # unstable
            }
          ];
        }
      ];
      icon = nixSnowflakeIcon;
      definedAliases = ["hmop"];
    };
    "GitHub repo" = {
      urls = [
        {
          template = "https://github.com/search/";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
            {
              name = "type";
              value = "repositories";
            }
          ];
        }
      ];
      definedAliases = ["gh"];
    };
    bing.metaData.hidden = "true";
  };
}
