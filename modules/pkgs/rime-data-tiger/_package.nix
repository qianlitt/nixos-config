{
  huma-rime,
  runCommand,
}:
runCommand "huma-rime-rime-data" {} ''
  mkdir -p $out/share/rime-data
  cp -r ${huma-rime}/. $out/share/rime-data/
''
