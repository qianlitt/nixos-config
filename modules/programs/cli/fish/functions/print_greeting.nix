{
  flake.modules.homeManager.fish = {
    programs.fish.functions = {
      print_greeting = {
        description = "Print a greeting with system information";
        body = ''
          # System info
          set -l os_info (os_info)
          set -l kernel_info (uname -sr)
          set -l arch (uname -m)
          set -l current_time (date)

          # System load
          set -l load (cat /proc/loadavg | cut -d ' ' -f1-3)
          set -l processes (ps -e | wc -l | string trim)

          # Disk usage
          set -l disk_usage
          if type -q df
              set disk_usage (df -h / | awk 'NR==2 {printf "%s of %s (%s)", $3, $2, $5}')
          else
              set disk_usage N/A
          end

          # Memory usage
          set -l memory_usage
          if type -q free
              set memory_usage (free -m | awk 'NR==2 {printf "%.0f%%", $3*100/$2}')
          else
              set memory_usage N/A
          end

          # Swap usage
          set -l swap_usage
          if type -q free
              set swap_usage (free -m | awk 'NR==3 {if ($2>0) printf "%.0f%%", $3*100/$2; else print "0%"}')
          else
              set swap_usage N/A
          end

          # Users logged in
          set -l users
          if type -q who
              set users (who | wc -l | string trim)
          else
              set users "?"
          end

          # IP address
          set -l ip_address
          if type -q ip
              for iface in (ip -4 -o link show | awk -F': ' '{print $2}' | grep -v lo)
                  set ip_address (ip -4 addr show $iface | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
                  if test -n "$ip_address"
                      break
                  end
              end
          else if type -q ifconfig
              set ip_address (ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n1 | cut -d' ' -f2)
          end
          if test -z "$ip_address"
              set ip_address N/A
          end

          # Build output
          echo "Welcome to $os_info (GNU/Linux $kernel_info $arch)"
          echo
          echo " System information as of $current_time"
          echo
          printf "  System load:  %-20s Processes:             %d\n" "$load" $processes
          printf "  Usage of /:   %-20s Users logged in:       %d\n" "$disk_usage" "$users"
          printf "  Memory usage: %-20s Swap usage:            %s\n" "$memory_usage" "$swap_usage"
          printf "  IPv4 address: \e[4;32m%s\e[0m\n\n" "$ip_address"

          # Last login information
          if type -q last
              set -l last_login (last_login)
              if test -n "$last_login"
                  echo -e "Last login: $last_login"
              else
                  echo "No login record found."
              end
          end
        '';
      };

      os_info = ''
        if type -q lsb_release
            lsb_release -ds | string trim
        else
            set -l os_name (grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
            set -l ansi_color (grep '^ANSI_COLOR=' /etc/os-release | cut -d= -f2 | tr -d '"')
            printf "\e[%sm%s\e[0m" $ansi_color $os_name
        end
      '';

      last_login = ''
        if not type -q last
            echo "last: command not found"
            return 1
        end

        set -l login_record (last -n1 $USER | head -n1)

        set -l Yellow '\033[0;33m'
        set -l UCyan '\033[4;36m'
        set -l Reset '\033[0m'

        # Match format by regex
        if string match -qr '.*pts/.*' "$login_record"
            # Remote login format: user tty ipv4 day month date time log-state
            echo $login_record | awk '{
                printf "'$Yellow'%s %s %s %s'$Reset' from '$UCyan'%s'$Reset'", $4, $5, $6, $7, $3
            }'
        else if string match -qr '.*tty.*' "$login_record"
            # Local login format: user tty day month date time log-state
            echo $login_record | awk '{
                printf "'$Yellow'%s %s %s %s'$Reset' on '$UCyan'%s'$Reset'", $3, $4, $5, $6, $2
            }'
        else if string match -qr '.*:.*' "$login_record"
            # Other format, such as systemd-logind
            echo $login_record | awk '{
                gsub(/^.*still logged in */, "")
                printf "'$Yellow'%s'$Reset'", $0
            }'
        end
      '';
    };
  };
}
