{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };
    opts = {
      # 文件与编辑
      autowrite = true; # 自动保存修改过的文件
      confirm = true; # 退出前确认
      undofile = true; # 持久化撤销
      undolevels = 10000; # 最大撤销步数
      updatetime = 200; # 更新间隔。较短的间隔对 LSP 诊断悬浮提示等更友好

      # 搜索与补全
      ignorecase = true; # 搜索时忽略大小写
      smartcase = true; # 智能大小写。若搜索词中包含大写字母，则自动区分大小写
      completeopt = "menu,menuone,noselect"; # 补全菜单行为。menu 显示菜单，menuone 即使只有一个匹配也显示，noselect 不自动选中第一项
      inccommand = "nosplit"; # 增量替换预览
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep"; # 将 `:grep` 命令替换为 `regrep`

      # UI
      cursorline = true; # 高亮当前行
      number = true; # 显示行号
      relativenumber = true; # 相对行号
      signcolumn = "yes"; # 固定标记列
      termguicolors = true; # 真彩色支持
      showmode = false; # 隐藏模式提示
      ruler = false; # 禁用标尺
      laststatus = 3; # 全局状态栏。整个窗口只使用一个状态栏
      mouse = "a"; # 鼠标支持。可在所有模式使用鼠标
      pumblend = 10; # popup menu 透明
      pumheight = 10; # popup menu 高度
      list = true; # 显示不可见字符
      listchars = {
        tab = "> ";
        trail = "·";
        nbsp = "␣";
      };
      fillchars = {
        foldopen = ""; # 展开折叠指示
        foldclose = ""; #  折叠指示
        fold = " "; # 折叠行填充
        foldsep = " "; # 折叠分隔
        diff = "╱"; # 区域填充
        eob = " "; # 文件末尾空行填充
      };
      conceallevel = 2; # 隐藏标记。将特定语法标记隐藏，直接渲染样式，但不隐藏带有替换文本的标记

      # 缩进
      expandtab = true; # 空格代替 Tab
      tabstop = 2; # Tab 显示宽度
      shiftwidth = 2; # 自动缩进宽度
      shiftround = true; # 缩进取整
      smartindent = true; # 智能缩进

      # 折叠
      foldtext = "";
      foldlevel = 99;
      foldmethod = "indent";

      # 窗口
      splitbelow = true; # 下方分割
      splitright = true; # 右侧分割
      splitkeep = "screen"; # 稳定屏幕。分割窗口时尽量保持屏幕内容不跳动
      winminwidth = 5; # 最小窗口宽度。窗口允许被缩小到的最小列数
      scrolloff = 4; # 垂直上下文。光标上下始终保留 4 行可见
      sidescrolloff = 8; # 水平上下文。光标左右始终保留 8 列可见
      wrap = false; # 禁用软换行。长行不会自动折行显示，而是超出屏幕右侧
      linebreak = true; # 若要折行，则在单词边界处断开
      virtualedit = "block"; # 可视块模式下，允许光标移动到行尾之后的空白区域
      smoothscroll = true; # 平滑滚动

      # 会话与消息
      sessionoptions = ["buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" "folds"]; # 会话保存内容
      shortmess = "ltToOCFWIcC"; # 缩短消息
      spelllang = ["en"]; # 拼写检查

      formatoptions = "jcroqlnt"; # 自动格式化选项
      jumpoptions = "view"; # 保存跳转视图
    };
  };
}
