# Module System Architecture

## 1. 概览

```mermaid
flowchart TB
    subgraph FlakeEntry [flake.nix — 构建入口]
        A["flake-parts.lib.mkFlake<br/>(import-tree ./modules)"]
    end

    subgraph Categories [模块分类 → flake.modules.*]
        direction TB
        N["NixOS 系统模块<br/>flake.modules.nixos.*"]
        H["Home Manager 模块<br/>flake.modules.homeManager.*"]
        D["Darwin 系统模块<br/>flake.modules.darwin.*"]
    end

    subgraph Infra [基础设施]
        direction TB
        F["框架<br/>framework/*.nix"]
        L["构建函数 + 工厂函数<br/>lib/*.nix"]
    end

    subgraph Outputs [flake outputs]
        C1["nixosConfigurations.&lt;host&gt;"]
        C2["homeConfigurations.&lt;user&gt;"]
    end

    A --> Infra
    A --> Categories

    L -.->|提供<br/>mkNixos / mkHomeManager / mkDarwin| Outputs
    N -->|被 lib.mkNixos 消费| C1
    H -->|被 lib.mkHomeManager 消费| C2
```

所有 `.nix` 文件通过 `import-tree ./modules` 被 flake.nix 统一加载，各自贡献到 `flake.modules.*`、`flake.lib.*`、`flake.nixosConfigurations` 等属性上。

---

## 2. `flake.modules.nixos.*` 途径

```mermaid
flowchart TB
    subgraph FlakeEntry [flake.nix]
        A["import-tree ./modules"]
    end

    subgraph Register [模块注册]
        direction TB
        SYS["system/*.nix<br/>— disko / grub / i18n / nix / sops / time …<br/>各产出 flake.modules.nixos.&lt;name&gt;"]
        PROF["profiles/*.nix<br/>— 将多个 system 模块打包为 profile<br/>— 可额外注入 HM bridge"]
        HOST["hosts/*/config.nix<br/>— imports profile + 主机级设置"]
        FACTORY["factory 生成模块<br/>— 用户账户 / HM 关联等模板"]
        BRIDGE["framework/home-manager.nix<br/>— 产出 flake.modules.nixos.home-manager<br/>— import home-manager.nixosModules"]
    end

    subgraph OutputDef [outputs 定义]
        O["hosts/*/flake-parts.nix<br/>flake.nixosConfigurations.&lt;host&gt;<br/>= lib.mkNixos &lt;system&gt; &lt;name&gt;"]
    end

    subgraph Build [构建 · nixpkgs.lib.nixosSystem]
        L["lib.mkNixos"]
        NIXOS["nixosSystem.modules=<br/>[self.modules.nixos.&lt;host&gt;]"]
    end

    subgraph Final [可构建产物]
        C["完整 NixOS 系统<br/>nixosConfigurations.&lt;host&gt;"]
    end

    A --> SYS
    A --> PROF
    A --> HOST
    A --> FACTORY
    A --> BRIDGE
    A --> O

    SYS -->|被 profile 聚合| PROF
    BRIDGE -->|被 profile 引入| PROF
    PROF -->|被 config 引入| HOST
    FACTORY -->|被 config 引入| HOST

    O -->|调用| L
    HOST -->|作为 self.modules.nixos.&lt;host&gt;<br/>被 mkNixos 读取| L
    L --> NIXOS
    NIXOS --> C

    style L fill:#533483,color:#fff
    style NIXOS fill:#e94560,color:#fff
    style C fill:#16c79a,color:#fff,stroke-width:2px
```

### 分层汇聚关系

```
system/*.nix      ──→ flake.modules.nixos.<功能>     (单一功能)
profiles/*.nix    ──→ flake.modules.nixos.<profile>   (功能聚合)
hosts/*/config.nix ──→ flake.modules.nixos.<host>     (主机全集)
```

最终 `lib.mkNixos` 将 `self.modules.nixos.<host>` 传给 `nixpkgs.lib.nixosSystem`。

---

## 3. `flake.modules.homeManager.*` 途径

```mermaid
flowchart TB
    subgraph FlakeEntry [flake.nix]
        A["import-tree ./modules"]
    end

    subgraph HmRegister [模块注册]
        U["users/*/elaina.nix<br/>flake.modules.homeManager.&lt;user&gt;<br/>= 用户 HM 配置"]
        HPROF["profiles/*.nix<br/>flake.modules.homeManager.*<br/>HM profile（可选）"]
    end

    subgraph Standalone [方式一：独立构建]
        SO["users/*/flake-parts.nix<br/>homeConfigurations.&lt;user&gt;<br/>= lib.mkHomeManager …"]
        SL["lib.mkHomeManager"]
        SHM["homeManagerConfiguration {<br/>  modules = [<br/>    self.modules.homeManager.&lt;user&gt;<br/>  ]<br/>}"]
        SC["homeConfigurations.&lt;user&gt;<br/>独立 HM 环境"]
    end

    subgraph Embedded [方式二：内嵌到 NixOS]
        EO["hosts/*/flake-parts.nix<br/>nixosConfigurations.&lt;host&gt;<br/>= lib.mkNixos …"]
        EL["lib.mkNixos → nixosSystem"]
        EBRIDGE["framework/home-manager.nix  →<br/>flake.modules.nixos.home-manager<br/>注册 home-manager.nixosModules"]
        EUSER["hosts/*/users/elaina.nix<br/>设置 home-manager.users.&lt;name&gt;.imports<br/>= [self.modules.homeManager.&lt;name&gt;]"]
        ENIXOS["nixosConfigurations.&lt;host&gt;<br/>含内嵌 HM 的完整 NixOS"]
    end

    A --> U
    A --> HPROF
    A --> SO
    A --> EO

    U -->|被 profile 引入| HPROF

    SO --> SL
    SL -->|读取 self.modules.homeManager.&lt;user&gt;| U
    SL --> SHM
    SHM --> SC

    EO --> EL
    EL --> EBRIDGE
    EL --> EUSER
    EUSER -->|imports| U
    EBRIDGE -.->|在 NixOS 中启用<br/>home-manager.users.*| EUSER
    EL --> ENIXOS

    style SL fill:#533483,color:#fff
    style SHM fill:#16c79a,color:#fff
    style ENIXOS fill:#e94560,color:#fff,stroke-width:2px
    style SC fill:#16c79a,color:#fff,stroke-width:2px
```

### 两种使用方式

| 方式 | 产出 | 适用场景 |
|---|---|---|
| **独立构建** | `homeConfigurations.<user>` | 非 NixOS 系统、单独测试 |
| **内嵌到 NixOS** | `nixosConfigurations.<host>` 内含 HM | NixOS 生产环境 |

内嵌链路：`framework/home-manager.nix` 产出 `flake.modules.nixos.home-manager`（即 NixOS 端的 HM 入口），被 profile 引入 NixOS 系统后，主机用户模块通过 `home-manager.users.<name>.imports` 指向 `self.modules.homeManager.<name>`。
