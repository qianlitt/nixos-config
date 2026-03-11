{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # programs.claude-code 打包存在两个主要问题：
  # 1. 默认会在每个 claude 命令后追加 --mcp-config 参数，导致 `claude mcp list` 等命令失败
  # 2. Nix Flake 中配置的 MCP 服务器在 VSCode 的 Claude Code 扩展中无法被正确发现

  # 临时解决方案：使用 home.packages 直接安装 claude-code 和 MCP 服务器依赖
  # 需手动执行 `claude mcp add` 命令来配置 MCP 服务器
  home.packages = with pkgs; [
    claude-code
    uv # MCP 服务器所需的 Python 依赖管理工具
  ];

  # TODO：封装 claude-code，实现 Nix 声明式管理 MCP 配置

  # Claude Code 所需的认证和配置
  sops.secrets = {
    "claude-code/api_key" = {};
    "claude-code/base_url" = {};
  };

  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "$(cat ${config.sops.secrets."claude-code/base_url".path})";
    ANTHROPIC_AUTH_TOKEN = "$(cat ${config.sops.secrets."claude-code/api_key".path})";
    ANTHROPIC_MODEL = "kimi-k2.5";
  };
}
