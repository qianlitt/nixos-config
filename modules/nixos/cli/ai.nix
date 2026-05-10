{
  config,
  lib,
  ...
}: let
  cfg = config.modules.cli.ai;
in {
  options.modules.cli.ai = {
    enable = lib.mkEnableOption "启用 llm-agents.nix 二进制缓存";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      extra-substituters = ["https://cache.numtide.com"];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };
}
