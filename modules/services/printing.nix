{
  flake.modules.nixos."services.printing" = {
    lib,
    pkgs,
    ...
  }: {
    services = {
      printing = {
        enable = true;
        cups-pdf = lib.mkDefault {
          enable = true;
          instances.pdf.settings = {
            Out = "\${HOME}/PDF"; # 输出到用户主目录的 PDF 文件夹
            UserUMask = "0033"; # 设置文件权限掩码
          };
        };

        drivers = lib.mkDefault (with pkgs; [
          cups-filters
          cups-browsed
          epson-escpr # 爱普生打印机驱动
        ]);
      };

      # 网络打印机自动发现
      avahi = lib.mkDefault {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      # USB 打印机自动发现
      ipp-usb.enable = lib.mkDefault true;
    };
  };
}
