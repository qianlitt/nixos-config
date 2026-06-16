{
  flake.modules.nixos.i18n = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.i18n;
  in {
    options.modules.i18n = {
      enable = lib.mkEnableOption "自定义多语言切换模块";

      profile = lib.mkOption {
        type = lib.types.enum ["zh" "en"];
        default = "zh";
        example = "en";
        description = "选择语言预设: zh (中文) 或 en (英文)";
      };
    };

    config = lib.mkIf cfg.enable (lib.mkMerge [
      {
        # 通用设置
        i18n.supportedLocales = [
          "en_US.UTF-8/UTF-8"
          "zh_CN.UTF-8/UTF-8"
        ];
      }

      # 中文预设
      (lib.mkIf (cfg.profile == "zh") {
        i18n = {
          # 定义 `LANG` 环境变量
          # 将设置程序消息的语言、日期和时间的格式、排序顺序等
          defaultLocale = "zh_CN.UTF-8";

          # 系统应支持的其他区域
          extraLocales = [
            "en_US.UTF-8/UTF-8"
            "zh_CN.UTF-8/UTF-8"
          ];

          extraLocaleSettings = {
            LC_ADDRESS = "zh_CN.UTF-8";
            LC_IDENTIFICATION = "zh_CN.UTF-8";
            LC_MEASUREMENT = "zh_CN.UTF-8";
            LC_MONETARY = "zh_CN.UTF-8";
            LC_NAME = "zh_CN.UTF-8";
            LC_NUMERIC = "zh_CN.UTF-8";
            LC_PAPER = "zh_CN.UTF-8";
            LC_TELEPHONE = "zh_CN.UTF-8";
            LC_TIME = "zh_CN.UTF-8";
          };
        };
      })

      # 英文预设
      (lib.mkIf (cfg.profile == "en") {
        i18n = {
          defaultLocale = "en_US.UTF-8";

          extraLocales = [
            "en_US.UTF-8/UTF-8"
            "zh_CN.UTF-8/UTF-8"
          ];

          extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
          };
        };
      })
    ]);
  };
}
