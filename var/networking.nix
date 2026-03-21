rec {
  gateway = "192.168.1.200";
  dns = ["192.168.1.200"];
  prefixLength = 24;

  host = {
    server-frieren = {
      hostName = "frieren";
      ip = "192.168.1.102";
      wirelessIp = "192.168.1.103";
    };
  };
}
