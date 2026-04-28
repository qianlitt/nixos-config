{
  inputs,
  mylib,
  ...
}: {
  imports =
    mylib.scanModules ./.
    ++ [inputs.nixvim.homeModules.nixvim];

  programs.nixvim = {
    enable = true;

    # 设置 'vi', 'vim' 的别名
    viAlias = true;
    vimAlias = true;

    # 设置空格键为<leader>
    globals.mapleader = " ";

    # 设置剪贴板支持
    clipboard = {
      # 使用 wl-copy
      providers.wl-copy.enable = true;

      # 系统剪贴板
      # unnamed: 在别处可以直接中键粘贴，但不会进入 Ctrl+V 的剪贴板
      # unnamedplus: 在别处可以直接 Ctrl+V 粘贴
      register = "unnamedplus";
    };
  };
}
