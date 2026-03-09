{
  a = "add";
  aa = "add --all";
  au = "add -update";
  apa = "add --patch";

  ap = "apply";

  b = "branch -vv";
  ba = "branch -a -v";
  ban = "branch -a -v --no-merged";
  bd = "branch -d";
  bD = "branch -D";

  # 显示指定文件中每一行的最后修改者和提交信息，忽略空白字符变化
  bl = "blame -b -w";

  # 通过二分法快速定位引入 bug 的提交
  bs = "bisect";
  bsb = "bisect bad";
  bsg = "bisect good";
  bsr = "bisect reset";
  bss = "bisect start";

  c = "commit -v";
  ca = "commit -v -a";
  cm = "commit -m";
  cam = "commit -a -m";
  cs = "commit -S";
  scam = "commit -S -a -m";
  cfx = "commit --fixup";

  cf = "config --list";

  cl = "clone";

  clean = "clean -di";

  count = "shortlog -sn";

  # 将指定的一个或多个其他分支上的提交，应用到当前分支
  cp = "cherry-pick";
  cpa = "cherry-pick --abort";
  cpc = "cherry-pick --continue";

  d = "diff";
  dca = "diff --cached";
  ds = "diff --stat";
  dsc = "diff --stat --cached";
  dt = "diff-tree --no-commit-id --name-only -r";
  dw = "diff --word-diff";
  dwc = "diff --word-diff --cached";
  dg = "diff --no-ext-diff";

  # 暂时忽略某些已跟踪文件的后续修改
  ignore = "update-index --assume-unchanged";
  unignore = "update-index --no-assume-unchanged";

  f = "fetch";
  fa = "fetch --all --prune";
  fo = "fetch origin";

  l = "pull";
  ll = "pull origin";
  lr = "pull --rebase";
  up = "pull --rebase";
  upv = "pull -rebase -v";
  upa = "pull --rebase --autostash";
  upav = "pull -rebase --autostash -v";

  lg = "log --stat";
  lgg = "log --graph";
  lgga = "log --graph --decorate --all";
  lo = "log --oneline --decorate --color";
  log = "log --oneline --decorate --color --graph";
  loga = "log --oneline --decorate --color --graph --all";

  m = "merge";

  p = "push";
  po = "push origin";
  pv = "push --no-verify";

  r = "remote -vv";
  ra = "remote add";

  rb = "rebase";
  rba = "rebase --abort";
  rbc = "rebase --continue";
  rbi = "rebase --interactive";

  # 创建一个撤销指定提交的提交
  rev = "revert";

  rh = "reset";
  rhh = "reset --hard";
  rhpa = "reset --patch";

  rm = "rm";
  rmc = "rm --cached";

  rmv = "remote rename";
  rpo = "remote prune origin";
  rrm = "remote remove";
  rs = "restore";
  rset = "remote set-url";
  rss = "restore --source";
  rst = "restore --staged";
  rup = "remote update";
  rv = "remote -v";

  sh = "show";

  st = "status";
  ss = "status -s";
  sb = "status -sb";

  sta = "stash";
  std = "stash drop";
  stl = "stash list";
  stp = "stash pop";
  sts = "stash show --text";

  su = "submodule update";
  sur = "submodule update --recursive";
  suri = "submodule update --recursive --init";

  ts = "tag -s";

  sw = "switch";
  swc = "switch --create";

  wch = "watchanged -p --abbrev-commit --pretty=medium";

  co = "checkout";
  cb = "checkout -b";

  wt = "worktree";
  wta = "worktree add";
  wtls = "worktree list";
  wtlo = "worktree lock";
  wtmv = "worktree move";
  wtpr = "worktree prune";
  wtrm = "worktree remove";
  wtulo = "worktree unlock";

  fb = "flow bugfix";
  ff = "flow feature";
  fr = "flow release";
  fh = "flow hotfix";
  fs = "flow support";
  fbs = "flow bugfix start";
  ffs = "flow feature start";
  frs = "flow release start";
  fhs = "flow hotfix start";
  fss = "flow support start";
  fbt = "flow bugfix track";
  fft = "flow feature track";
  frt = "flow release track";
  fht = "flow hotfix track";
  fst = "flow support track";
  fp = "flow publish";
}
