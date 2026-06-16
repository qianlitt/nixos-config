{
  flake.modules.homeManager.fish = {
    programs.fish.functions = {
      check_env = {
        description = "Check current environment";
        body = ''
          if set -q ZELLIJ
              printf zellij
          else if set -q TERM_PROGRAM && test "$TERM_PROGRAM" = vscode
              printf vscode
          else if set -q SSH_CONNECTION || set -q SSH_CLIENT || set -q SSH_TTY
              printf ssh
          else if set -q KITTY_PID
              printf kitty
          else if test "$TERM" = foot
              printf foot
          else
              set tty_device (tty)
              if string match -qr '^/dev/tty[0-9]+' -- $tty_device
                  printf tty
              else
                  printf other
              end
          end
        '';
      };
    };
  };
}
