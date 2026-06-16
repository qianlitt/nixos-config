## TODO

- [ ] niri 等待上游修复 BUG: [regression (Nvidia): Niri hogs all the VRAM, external display blank · Issue #4113 · niri-wm/niri](https://github.com/niri-wm/niri/issues/4113)
- [ ] noctalia v5 配置发生较大变动，需要重新配置
- [ ] 编写文档指导新建模块、主机和用户
- [ ] 重新思考模块结构
  - 导入即启用。模块只包含通用配置，更精细的配置在 `modules/hosts/*/config.nix` 和 `modules/hosts/*/users/` 中完成
  - 精简 `modules/profiles` 中导入的模块，同样只包含通用配置