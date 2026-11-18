{
  flake.modules.nixos.displayManager = {
    services.displayManager.ly = {
      enable = true;
      settings = {
        ly_log = "/var/log/ly.log";
        session_log = ".local/state/ly-session.log";
      };
    };
  };
}
