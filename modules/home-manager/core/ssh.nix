{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      # 此处的顺序不重要，由 nix 自动合并
      "*" = {
        forwardAgent = false; # 禁用代理转发
        compression = false; # 禁用压缩
        addKeysToAgent = "yes"; # 自动将密钥添加到 ssh-agent
        hashKnownHosts = true; # 在 known_hosts 文件中使用哈希化主机名，可用 `ssh-keygen -R <hostname>` 从 known_hosts 中删除主机
        userKnownHostsFile = "~/.ssh/known_hosts";

        serverAliveInterval = 60; # 每 60 秒发送一次 keep-alive 消息
        serverAliveCountMax = 3; # 如果连续 3 次没有响应，则断开连接
        controlMaster = "auto"; # 自动复用已有连接
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "10m"; # 主连接退出后 10 分钟内保留后台监听
      };

      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };
}
