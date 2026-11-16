# Sops

## 需要哪些密钥

| Key      | 存放方式                                     | 作用     |
| :------- | :------------------------------------------- | :------- |
| 管理密钥 | 只存放在日常使用的 PC 上，不要部署在服务器上 | 日常使用 |
| 主机密钥 | 每台主机生成一次，**不要复用**               |          |
| 用户密钥 | 每个 Home Manager 用户一个，同样**不复用**   |          |

规则：

- **私钥**不进 git、不进 `secrets/`、不进 nix store。
- **主机密钥**的 owner 必须是 root，权限是 `400`。

## secret 文件

每个文件对应一个解密范围。同一个文件里的所有 secret，必须能被同一组 key 解密。

| 文件                | recipient                         | 放什么                |
| :------------------ | :-------------------------------- | :-------------------- |
| `common.yaml`       | admin、所有主机密钥、所有用户密钥 | 所有主机都需要的内容  |
| `hosts/<host>.yaml` | admin、该主机自己密钥             | 主机各自需要的内容    |
| `users/<user>.yaml` | admin、该用户自己密钥             | HM 用户各自需要的内容 |

> [!tip] 示例
> - 用户密码 $\to$ `common.yaml`/`hosts/<host>.yaml`：用户密码位于 NixOS 层
> - WiFi $\to$ `common.yaml`
> - 服务 $\to$ `hosts/<host>.yaml`

## 流程

### 添加主机

#### 1. 生成主机专用密钥

在管理机上：

```shell
age-keygen -o /path/to/new-host.age.key
```

#### 2. 公钥写入 `.sops.yaml`

生成的文件中也包含公钥，或者用命令 `age-keygen -y /path/to/file` 输出公钥。

然后将公钥写入 `.sops.yaml`，并添加 `creation_rules`。这 `creation_rules` 的 `key_groups` 只包含 `admin`、`host_<newhost>`，不要加上其他主机的密钥。

#### 3. `sops updatekeys`

> [!note] `sops updatekeys` 运行过程
> 1. 用旧私钥解出“数据密钥”。
> 2. 用新公钥重新包装这个数据密钥。
> 3. 写回。

`sops updatekeys` 至少需要一个可以解密的私钥（通常是 admin）。

#### 4. 配置主机模块

1. 配置 `sops.age.keyFile` age 密钥路径。
2. 配置 `defaultSopsFile` 或 `sopsFile`。

同时全局显式关闭 SSH host key 作为 sops 身份：

```nix
sops.age.sshKeyPaths = lib.mkDefault [];
sops.gnupg.sshKeyPaths = lib.mkDefault [];
```

#### 5. （可选）打包和检测

```shell
#!/usr/bin/env bash
extra=$(mktemp -d)
host=<host>
user=<user>

# 系统级主机密钥
install -d -m 700 "$extra/var/lib/sops-nix"
install -m 400 ~/sops-keys/hosts/$host.age.key \
  "$extra/var/lib/sops-nix/host-key.txt"

# HM 用户密钥
install -d -m 700 "$extra/home/$user/.config/sops/age"
install -m 600 ~/sops-keys/users/$user.age.key \
  "$extra/home/$user/.config/sops/age/keys.txt"

# 检测能否正常解密
# HOME=/nonexistent 防止 sops 回退到 ~/.config/sops/age/keys.txt（admin 密钥）
HOME=/nonexistent SOPS_AGE_KEY_FILE="$extra/var/lib/sops-nix/host-key.txt" \
  sops -d secrets/hosts/$host.yaml >/dev/null && echo "host key OK"
HOME=/nonexistent SOPS_AGE_KEY_FILE="$extra/home/$user/.config/sops/age/keys.txt" \
  sops -d secrets/users/$user.yaml >/dev/null && echo "HM key OK"
```

#### 6. （可选）`nixos-anywhere` 安装

```shell
nix run github:nix-community/nixos-anywhere -- \
  --flake .#<newhost> \
  --target-host root@<installer-ip> \
  --phases disko,install \
  --extra-files "$extra" \
  --chown var/lib/sops-nix 0:0 \
  --chown home/<user> 1000:100
```

#### 7. 验证

```shell
# 主机密钥：root 所有
ls -l /var/lib/sops-nix/host-key.txt
# 期望 -r-------- root root

# 密钥身份是否与 .sops.yaml 一致
age-keygen -y /var/lib/sops-nix/host-key.txt
# 期望 host_<host> 公钥
age-keygen -y /home/elaina/.config/sops/age/keys.txt
# 期望 user_elaina 公钥

# 系统 secret 是否成功生成
sudo ls -l /run/secrets/...

# HM 密钥：elaina 所有
ls -l /home/elaina/.config/sops/age/keys.txt
# 期望 -rw------- elaina elaina（或对应 uid/gid）

# HM secret 是否成功生成
sudo -u elaina ls -l /run/user/1000/secrets/...   # 路径取决于 HM 配置
```

### 密钥泄露

1. 生成新密钥。
2. 新公钥写入 `.sops.yaml`。
3. 运行 `sops updatekeys`，将泄露的密钥从 data key 封装中移除。
4. 使用 `sops rotate` 生成全新的 data key。

批量处理：

```shell
find secrets -name '*.yaml' -print0 | while IFS= read -r -d '' file; do
  sops updatekeys --yes "$file" && sops rotate -i "$file"
done
```
