{
  programs.fish.shellAbbrs = {
    # ls
    ls = "eza";
    ll = "eza -l";
    la = "eza -A";
    lla = "eza -lA";
    lf = "eza -alf";
    ldir = "eza -alD";
    lt = "eza -T";
    tree = "eza -T";

    # neovim
    nv = "nvim";
    nvc = "nvim --clean";

    # cargo
    cgs = "cargo search --registry crates-io";
    cgi = "cargo info --registry crates-io";

    # git
    glss = "git log --show-signature";
    glsp = "git log --pretty=\"%h %G? %aN %s\"";

    # fastfetch
    ff = "fastfetch -c examples/6";

    ip = "ip -c";
    df = "df -h";
    du = "du -sh";
    py = "python";
    yz = "yazi";
  };
}
