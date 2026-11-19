{
  flake.modules.nixos."services.ssh" = {lib, ...}: {
    services.openssh = {
      enable = true;

      openFirewall = true;

      settings = {
        # Authentication
        PermitRootLogin = lib.mkDefault "no";
        PubkeyAuthentication = lib.mkDefault true; # 明确启用公钥认证
        PasswordAuthentication = lib.mkDefault false;
        KbdInteractiveAuthentication = lib.mkDefault false; # 禁止 keyboard-interactive，避免通过 PAM 等方式重新引入交互式密码认证
        PermitEmptyPasswords = lib.mkDefault false; # 禁止空密码

        # Access control
        AllowUsers = lib.mkDefault null; # 只允许指定用户登录

        # Brute-force mitigation
        MaxAuthTries = lib.mkDefault 3; # 限制单次连接的认证尝试次数
        LoginGraceTime = lib.mkDefault "30s"; # 限制未完成认证的连接时间
        MaxSessions = lib.mkDefault 3; # 限制单个 SSH 连接的会话数量

        # Reduce attack surface
        X11Forwarding = lib.mkDefault false; # 禁止图形界面转发
        AllowAgentForwarding = lib.mkDefault false; # 禁止 SSH Agent 转发
        PermitTunnel = lib.mkDefault false; # 禁止 SSH TUN/TAP 隧道
        PermitUserEnvironment = lib.mkDefault false; # 禁止用户通过环境文件影响 SSH 会话

        # Session
        PermitTTY = lib.mkDefault true;
        PrintMotd = lib.mkDefault false;
      };
    };
  };
}
