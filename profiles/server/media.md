# 媒体服务器配置指南

尽管使用 Nix 管理我的媒体服务器，仍有些设置需要手动完成。

## 1. Jellyfin

- 设置**语言**、**媒体库**就万事大吉了。

## 2. Radarr

1. 设置认证方式。
2. 改 UI 语言：Settings -> UI -> Language -> UI Language。
3. 媒体设置：
   1. 勾选**重命名电影**。
   2. 添加**根目录**。
4. 设置下载器。

> Radarr 和之后的 Sonarr、Prowlarr 在设置后都要点击**保存更改**。

## 3. Sonarr

基本与 [Radarr](#2-radarr) 相同。

## 4. qBittorrent

qBittorrent 自身的设置都由 Nix 完成了。只需配置：

- radarr 和 tv-sonarr 分类的保存路径。

> 不配置似乎也可以。

## 5. Prowlarr

1. 如同 [Radarr](#2-radarr) 一样设置认证方式，改语言。
2. 添加索引器。
3. 在 `设置->应用程序` 中添加 Radarr 和 Sonarr。

## 6. [JProxy](https://github.com/LuckyPuppy514/jproxy)

- 默认用户：`jproxy`
- 默认密码：`jproxy@2023`

依照[基础配置](https://github.com/LuckyPuppy514/jproxy#%EF%B8%8F-%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE)和[进阶配置](https://github.com/LuckyPuppy514/jproxy/wiki#%E8%BF%9B%E9%98%B6%E9%85%8D%E7%BD%AE)进行设置。

## 7. Seerr

1. 选择 Jellyfin。
2. 登录 Jellyfin，并同步 Jellyfin 的媒体库。
3. 设置 Radarr 和 Sonarr。

---

参考：[全网影视自动收割机！*arr全家桶流水线](https://www.bilibili.com/video/BV1iMYizbEfu/)