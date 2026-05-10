{
  config,
  lib,
  inputs,
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
    home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      # AI Coding Agents
      claude-code
      codex
      oh-my-codex
      opencode
      oh-my-opencode

      # Utilities
      cc-switch-cli
    ];
  };
}
