{
  programs.fish.interactiveShellInit = ''
    # 取消问候语
    set -g fish_greeting

    # 设置 fzf 默认选项
    set -x FZF_DEFAULT_OPTS "--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always {}' --preview-window '~3' --bind up:preview-up,down:preview-down"

    # 根据环境进行初始化
    set -l env_type (check_env)
    set -l load_starship false
    set -l show_greeting false
    set -l start_zellij false

    switch $env_type
        case vscode kitty foot
            # 启动 starship
            set load_starship true

        case ssh
            # zellij 存在时自动连接
            if type -q zellij
                set start_zellij true
            end

        case zellij
            # 启动 starship 和问候语
            set show_greeting true
            set load_starship true

        case tty
            # 显示问候语
            set show_greeting true

        case *
            # 其他未知环境
            set show_greeting true
    end

    # 加载 starship
    if $load_starship
        starship init fish | source
    end

    # 打印问候语
    if $show_greeting
        print_greeting
    end

    if $start_zellij
        exec zellij attach --create # 启动 zellij 并自动连接到现有会话或创建新会话
    end

    # 补充 Abbrs
    # ssh
    if test "$TERM" = xterm-kitty
        abbr -a -- ssh "kitty +kitten ssh"
    end
  '';
}
