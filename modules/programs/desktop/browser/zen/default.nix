{inputs, ...}: {
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  flake.modules.homeManager.zen-browser = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.zen-browser.homeModules.twilight
    ];

    programs.zen-browser = {
      enable = true;
      languagePacks = ["zh-CN"];

      policies = import ./_policies.nix;

      profiles.default = {
        settings = {
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.animate-sidebar" = false;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.sidebar-expanded" = true;
          "zen.view.use-single-toolbar" = false;
          "zen.urlbar.behavior" = "float";
        };
        search = import ./_search.nix {inherit pkgs;};

        containers = {
          "私人" = {
            icon = "fingerprint";
            color = "purple";
            id = 1;
          };
          "办公" = {
            color = "orange";
            icon = "briefcase";
            id = 2;
          };
          "金融" = {
            color = "green";
            icon = "dollar";
            id = 3;
          };
          "购物" = {
            color = "pink";
            icon = "cart";
            id = 4;
          };
        };
        spaces =
          # $HOME/.zen/<profiles>/places.sqlite
          let
            containers = config.programs.zen-browser.profiles."default".containers;
          in {
            "Space" = {
              id = "51c83e07-2c63-43ac-b42b-d9cfda4c8bd8";
              icon = "🏠️";
              position = 1000;
              container = containers."私人".id;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 24;
                    green = 15;
                    blue = 36;
                    custom = false;
                    algorithm = "floating";
                    lightness = 10;
                    position = {
                      x = 171;
                      y = 72;
                    };
                    type = "explicit-lightness";
                  }
                ];
              };
            };
            "Work" = {
              id = "54b759e9-22cb-499d-ba52-3e3e2bfd1644";
              icon = "chrome://browser/skin/zen-icons/selectable/terminal.svg";
              container = containers."办公".id;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 114;
                    green = 192;
                    blue = 141;
                    custom = false;
                    algorithm = "analogous";
                    lightness = 60;
                    position = {
                      x = 93;
                      y = 254;
                    };
                    type = "explicit-lightness";
                  }
                  {
                    red = 121;
                    green = 177;
                    blue = 185;
                    custom = false;
                    algorithm = "analogous";
                    lightness = 60;
                    position = {
                      x = 55;
                      y = 165;
                    };
                    type = "explicit-lightness";
                  }
                  {
                    red = 157;
                    green = 199;
                    blue = 107;
                    custom = false;
                    algorithm = "analogous";
                    lightness = 60;
                    position = {
                      x = 185;
                      y = 282;
                    };
                    type = "explicit-lightness";
                  }
                ];
              };
              position = 2000;
            };
            "Research" = {
              id = "ec287d7f-d910-4860-b400-513f269dee77";
              icon = "🔎";
              container = containers."私人".id;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 230;
                    green = 178;
                    blue = 223;
                    custom = false;
                    algorithm = "analogous";
                    lightness = 80;
                    position = {
                      x = 236;
                      y = 111;
                    };
                    type = "explicit-lightness";
                  }
                  {
                    red = 234;
                    green = 175;
                    blue = 174;
                    custom = false;
                    algorithm = "analogous";
                    lightness = 80;
                    position = {
                      x = 256;
                      y = 183;
                    };
                    type = "explicit-lightness";
                  }
                  {
                    red = 198;
                    green = 181;
                    blue = 227;
                    custom = false;
                    algorithm = "analogous";
                    lightness = 80;
                    position = {
                      x = 168;
                      y = 80;
                    };
                    type = "explicit-lightness";
                  }
                ];
              };
              position = 3000;
            };
          };
      };
    };
  };
}
