rec {
  user = {
    name = "elaina";
    email = "zvdiek@gmail.com";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIql1DkkFW4n1tntQxVblT3+9Lv/d8hm7i7JWZEfzrbx bitwarden@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqTv14u4PA/Vox3HYIthOutdu9u6wSOVTWPAUf+2Gd5 openpgp"
    ];
  };

  networking = import ./networking.nix;

  git = {
    user = {
      name = "qianlitt";
      email = user.email;
    };
    signingKey = "C6D152AC471FA822";
  };
}
