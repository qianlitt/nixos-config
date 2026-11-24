{inputs, ...}: {
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  flake.modules.nixos.ai = {lib, ...}: {
    # llm-agents 缓存
    nix.settings = {
      substituters = lib.mkOrder 700 ["https://cache.numtide.com"];
      trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };

  flake.modules.homeManager.ai = {pkgs, ...}: let
    ps = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    # llm-agents.nix: https://github.com/numtide/llm-agents.nix
    home.packages =
      (with pkgs; [uv nodejs]) # MCP Dependencise
      ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        # AI Coding Agents
        claude-code
        codex
        dsh

        # Utilities
        cc-switch-cli

        ps.learnharness
      ]);
  };
}
