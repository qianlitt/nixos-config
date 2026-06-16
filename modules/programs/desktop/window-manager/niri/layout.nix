{
  flake.modules.homeManager.niri = {
    programs.niri.settings.layout = {
      gaps = 10;
      center-focused-column = "never"; # 切换焦点时，不将焦点所在列居中
      always-center-single-column = true; # 当只有一列时，该列居中
      empty-workspace-above-first = true; # 上下都有空工作区

      default-column-width = {proportion = 0.5;}; # 默认列宽
      preset-window-heights = [
        # 预设窗口宽度
        {proportion = 1. / 3.;}
        {proportion = 1. / 2.;}
        {proportion = 2. / 3.;}
      ];

      # 为窗口绘制边框
      focus-ring.enable = false;
      border = {
        enable = true;
        width = 2.2;
        active.color = "#d8dee9";
        inactive.color = "#434c5e";
        urgent.color = "#bf616a";
      };

      # 增加窗口与屏幕边缘的距离，避免窗口被遮挡
      struts = {
        left = 2;
        right = 2;
        top = 2;
        bottom = 2;
      };

      # 窗口阴影
      shadow = {
        enable = true;
        spread = 0;
        softness = 10;
        color = "#000000dd";
      };
    };
  };
}
