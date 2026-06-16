{
  flake.modules.nixos.audio = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.desktop.audio;
  in {
    options.modules.desktop.audio = {
      enable = lib.mkEnableOption "启用音频配置";
    };

    config = lib.mkIf cfg.enable {
      # rtkit 允许 PipeWire 进程请求实时调度策略，显著降低音频延迟
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
  };
}
