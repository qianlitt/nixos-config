{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  programs.claude-code = {
    enable = true;
  };

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
