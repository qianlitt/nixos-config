# Hosts

该目录包含各主机的特定配置。

## Current Host

| Host           | Platform     | Hardware       | Purpose | Status   |
| -------------- | ------------ | -------------- | ------- | -------- |
| server-frieren | x86_64-linux | i7-310M + 310M | Server  | ✅ Active |

<a id="naming-convention"></a>
> [!NOTE] Naming Convention
>
> 目录名遵循“用途-主机名”的格式。例如，`server-frieren` 表示这是一个主机名为 frieren 的服务器。
>
> - 主机名使用动漫角色的名称。
> - 用户名就统一使用《魔女之旅》主人公的名字——伊蕾娜（elaina）。

# Guide

## Adding a New Host

1. 依照[命名规范](#naming-convention)创建一个新的目录，也可复制一份现有的配置。
2. 复制新主机的 `hardware-configuration.nix` 到 `host/<name>/hardware-configuration.nix`。
3. 创建并复制新主机的 `configuration.nix` 到 `host/<name>/default.nix`（这使其成为一个模块）。
4. 在 `flake.nix` 的 outputs 引用新主机的配置模块。