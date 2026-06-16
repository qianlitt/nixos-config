{
  flake.modules.homeManager.fish = {
    programs.fish.functions = {
      ex = {
        description = "Extract various archive formats";
        body = ''
          if test (count $argv) -ne 1
              echo "Usage: ex <file>"
              return 1
          end

          set file $argv[1]

          if not test -f "$file"
              echo "$(set_color red)Error: '$file' is not a valid file"
              return 1
          end

          switch "$file"
              case "*.tar.bz2"
                  tar xvjf $file
              case "*.tar.gz"
                  tar xvzf $file
              case "*.bz2"
                  bunzip2 $file
              case "*.rar"
                  unrar x $file
              case "*.gz"
                  gunzip $file
              case "*.tar"
                  tar xvf $file
              case "*.tbz2"
                  tar xvjf $file
              case "*.tgz"
                  tar xvzf $file
              case "*.zip"
                  unzip $file
              case "*.Z"
                  uncompress $file
              case "*.7z"
                  7z x $file
              case "*"
                  echo "$(set_color red)Error: '$file' cannot be extracted via ex()"
          end
        '';
      };
    };
  };
}
