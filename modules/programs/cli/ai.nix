{inputs, ...}: {
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  flake.modules.nixos.ai = {
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
  };

  flake.modules.homeManager.ai = {
    config,
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    cfg = config.modules.cli.ai;

    nixosAiEnabled = osConfig.modules.cli.ai.enable;
  in {
    options.modules.cli.ai = {
      enable = lib.mkEnableOption "安装 AI 应用";
    };

    config = lib.mkIf cfg.enable {
      warnings = lib.optional (!nixosAiEnabled) ''
        建议启用 llm-agets.nix 的二进制缓存，请在 Nixos Modules 中添加:
          `modules.cli.ai.enable = true;`
      '';

      # llm-agents.nix: https://github.com/numtide/llm-agents.nix
      home.packages =
        (with pkgs; [uv nodejs]) # MCP Dependencise
        ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
          # AI Coding Agents
          claude-code
          codex
          oh-my-codex
          opencode
          oh-my-opencode

          # Utilities
          cc-switch-cli
        ]);
    };
  };
}
