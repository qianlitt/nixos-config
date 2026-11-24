{
  perSystem = {pkgs, ...}: {
    packages.learnharness = pkgs.callPackage (
      {
        lib,
        stdenv,
        fetchurl,
        fetchNpmDeps,
        buildNpmPackage,
        nodejs_24,
        electron_44,
        autoPatchelfHook,
        makeWrapper,
        copyDesktopItems,
        makeDesktopItem,
        zlib,
        jetbrains-mono,
        source-sans,
      }: let
        pname = "learnharness";
        version = "0.7.0";

        sourceRoot = "${pname}-${version}";

        # Source archive.
        src = fetchurl {
          url = "https://github.com/amosblomqvist/learnharness/archive/refs/tags/v${version}.tar.gz";
          hash = "sha256-1gTcjeu0L0jJa1VraRcAPaFTYaQcVjD1AVD7dobxRvI=";
        };

        # Each Core Plugin has an independent package-lock.json.
        # Therefore, each plugin requires its own npm dependency cache.
        pluginDeps = {
          flashcards = fetchNpmDeps {
            name = "${pname}-flashcards-npm-deps";
            inherit src;
            sourceRoot = "${sourceRoot}/plugins/flashcards";
            hash = "sha256-AGjSn0TFK8jx3VpgAROg9fjhZ7gT6CKBD6vr+FbZJKE=";
          };

          coding-questions = fetchNpmDeps {
            name = "${pname}-coding-questions-npm-deps";
            inherit src;
            sourceRoot = "${sourceRoot}/plugins/coding-questions";
            hash = "sha256-qge3Z50q70bjCRgYAnSezG3Jx4y64wvJYepp7511hAM=";
          };

          drawing-pad = fetchNpmDeps {
            name = "${pname}-drawing-pad-npm-deps";
            inherit src;
            sourceRoot = "${sourceRoot}/plugins/drawing-pad";
            hash = "sha256-SbiwseLd9dhSBNDTbr9jfbr6zruoYH5pXUSb2I6roJY=";
          };

          rich-code-blocks = fetchNpmDeps {
            name = "${pname}-rich-code-blocks-npm-deps";
            inherit src;
            sourceRoot = "${sourceRoot}/plugins/rich-code-blocks";
            hash = "sha256-2wt84ICmHf7YywZzLQRVswMBg99OAp43nnt9tJZcupw=";
          };

          ui-showcase = fetchNpmDeps {
            name = "${pname}-ui-showcase-npm-deps";
            inherit src;
            sourceRoot = "${sourceRoot}/plugins/ui-showcase";
            hash = "sha256-1Y1dMZIsM/EmInSd5HOFojDNHLAqrhn68bdON5V4Czw=";
          };
        };
      in
        buildNpmPackage {
          inherit pname version src sourceRoot;

          # Root package-lock.json.
          npmDepsHash = "sha256-ink0rVziD1xk3dVq9ORWXIe03ISSlpDuBfXtzDBBNbA=";

          nodejs = nodejs_24;

          nativeBuildInputs = [
            autoPatchelfHook
            makeWrapper
            copyDesktopItems
          ];

          buildInputs = [
            electron_44
            stdenv.cc.cc.lib
            zlib
          ];

          env = {
            NEXT_TELEMETRY_DISABLED = "1";

            # Electron is provided by nixpkgs.
            ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

            npm_config_audit = "false";
            npm_config_fund = "false";
          };

          # Replace next/font/google with next/font/local.
          postPatch = ''
            mkdir -p app/fonts

            # Install JetBrains Mono under the filename expected by Next.js.
            jetbrainsMonoFont="$(
              find ${jetbrains-mono}/share/fonts \
                -type f -iname '*.ttf' -print -quit
            )"

            if [ -z "$jetbrainsMonoFont" ]; then
              echo "JetBrains Mono TTF font not found" >&2
              exit 1
            fi

            install -Dm644 \
              "$jetbrainsMonoFont" \
              app/fonts/jetbrains-mono.ttf

            # Install Source Sans 3 under the filename expected by Next.js.
            sourceSansFont="$(
              find ${source-sans}/share/fonts \
                -type f -iname '*.ttf' -print -quit
            )"

            if [ -z "$sourceSansFont" ]; then
              echo "Source Sans 3 TTF font not found" >&2
              exit 1
            fi

            install -Dm644 \
              "$sourceSansFont" \
              app/fonts/source-sans-3.ttf

            # Replace next/font/google with next/font/local.
            substituteInPlace app/layout.tsx \
              --replace-fail \
                'import { JetBrains_Mono, Source_Sans_3 } from "next/font/google";' \
                'import localFont from "next/font/local";' \
              --replace-fail \
                'const ui = JetBrains_Mono({ subsets: ["latin"], variable: "--font-jetbrains" });' \
                'const ui = localFont({ src: "./fonts/jetbrains-mono.ttf", variable: "--font-jetbrains", weight: "100 800", style: "normal" });' \
              --replace-fail \
                'const prose = Source_Sans_3({ subsets: ["latin"], variable: "--font-sans3" });' \
                'const prose = localFont({ src: "./fonts/source-sans-3.ttf", variable: "--font-sans3", weight: "200 900", style: "normal" });'
          '';

          # Prepare independent Core Plugin dependencies.
          preBuild = ''
            (
              set -euo pipefail

              preparePlugin() {
                local name="$1"
                local cache="$TMPDIR/npm-cache-$name"
                local project="$PWD/plugins/$name"

                echo "Preparing plugin: $name"

                # Copy the independent npm dependency cache.
                case "$name" in
                  flashcards)
                    cp -a ${pluginDeps.flashcards} "$cache"
                    ;;
                  coding-questions)
                    cp -a ${pluginDeps.coding-questions} "$cache"
                    ;;
                  drawing-pad)
                    cp -a ${pluginDeps.drawing-pad} "$cache"
                    ;;
                  rich-code-blocks)
                    cp -a ${pluginDeps.rich-code-blocks} "$cache"
                    ;;
                  ui-showcase)
                    cp -a ${pluginDeps.ui-showcase} "$cache"
                    ;;
                  *)
                    echo "Unknown plugin: $name" >&2
                    exit 1
                    ;;
                esac

                # npm may update cache metadata during installation.
                chmod -R u+w "$cache"

                # Generate the local LearnHarness Plugin SDK.
                #
                # TypeScript plugins use:
                #   "learnharness-plugin-api": "file:.sdk"
                #
                # The SDK must exist before npm ci.
                #
                # The upstream sdk script invokes:
                #   node ../../scripts/build-plugin-types.mjs .sdk
                #
                # It generates the SDK directly into the plugin's .sdk directory.
                if node -e '
                  const pkg = require(process.argv[1]);
                  process.exit(pkg.scripts?.sdk ? 0 : 1);
                ' "$project/package.json"; then
                  npm --prefix "$project" run sdk
                fi

                # Install from the prefetched npm cache.
                # No network access is required.
                npm --prefix "$project" ci \
                  --offline \
                  --cache "$cache" \
                  --no-audit \
                  --no-fund
              }

              preparePlugin flashcards
              preparePlugin coding-questions
              preparePlugin drawing-pad
              preparePlugin rich-code-blocks
              preparePlugin ui-showcase
            )
          '';

          postBuild = ''
            (
              set -euo pipefail

              node scripts/smoke-provider-runtime.mjs
              node scripts/build-server.mjs
              node scripts/smoke-server.mjs --isolated
            )
          '';

          installPhase = ''
            runHook preInstall

            app="$out/share/learnharness"
            server="$app/server/standalone"

            mkdir -p "$app/electron" "$app/server" "$out/bin"

            # Electron shell only.
            cp -a electron/. "$app/electron/"
            install -Dm644 package.json "$app/package.json"

            # Next.js standalone payload.
            # build-server.mjs has already curated this directory.
            cp -a .next/standalone "$server"

            # Preserve upstream Electron resource layout.
            substituteInPlace "$app/electron/main.cjs" \
              --replace-fail \
                'return path.join(process.resourcesPath, "server", "standalone", "server.js");' \
                'return process.env.LH_SERVER_ENTRY || path.join(process.resourcesPath, "server", "standalone", "server.js");'

            # Disable electron-updater in Nix-managed installations.
            substituteInPlace "$app/electron/main.cjs" \
              --replace-fail \
                'function setupAutoUpdater() {' \
                'function setupAutoUpdater() {
                  if (process.env.LH_DISABLE_UPDATES === "1") {
                    log("auto-update: disabled by Nix package");
                    reportUpdateStatus("disabled");
                    return;
                  }'

            # Application icon.
            install -Dm644 \
              build/icon.png \
              "$out/share/icons/hicolor/512x512/apps/learnharness.png"

            # Desktop launcher.
            makeWrapper ${lib.getExe electron_44} \
              "$out/bin/learnharness" \
              --add-flags "$app" \
              --set LH_SERVER_ENTRY "$server/server.js" \
              --set LH_DISABLE_UPDATES "1"

            runHook postInstall
          '';

          desktopItems = [
            (makeDesktopItem {
              name = "learnharness";
              desktopName = "LearnHarness";
              comment = "An agent harness for learning";
              exec = "learnharness";
              icon = "learnharness";
              categories = [
                "Education"
              ];
              terminal = false;
            })
          ];

          dontStrip = true;

          meta = {
            description = "An agent harness for learning";
            homepage = "https://github.com/amosblomqvist/learnharness";
            changelog = "https://github.com/amosblomqvist/learnharness/releases/tag/v${version}";

            license = lib.licenses.agpl3Only;

            platforms = [
              "x86_64-linux"
            ];

            mainProgram = "learnharness";
          };
        }
    ) {};
  };
}
