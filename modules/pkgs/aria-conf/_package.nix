{fetchFromGitHub}:
fetchFromGitHub {
  owner = "P3TERX";
  repo = "aria2.conf";
  rev = "02b9d95ea155e66f7e3c4340cd22717f8bc7401c";
  hash = "sha256-O7g/oGgANgoChKACAKzLIOOUbacWpHCEsH533eJwePo=";
  postFetch = ''
    chmod +x "$out"/*.sh || true
  '';
}
