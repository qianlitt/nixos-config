{lib, ...}: rec {
  /*
  * 扫描指定目录，返回符合 Nix 模块规范的绝对路径列表
  *
  * 规范：
  * - 普通文件：以 .nix 结尾，且不是 default.nix
  * - 目录：必须包含 default.nix
  */
  scanModules = path: let
    content = builtins.readDir path;

    isValidModule = name: type: let
      fullPath = path + "/${name}";
    in
      if type == "regular"
      then lib.hasSuffix ".nix" name && name != "default.nix"
      else type == "directory" && builtins.pathExists (fullPath + "/default.nix");
  in
    lib.mapAttrsToList (name: _: path + "/${name}")
    (lib.filterAttrs isValidModule content);

  # ========== 谓词工厂 (Predicate Factories) ==========

  # 排除指定名称列表中的任意一个
  excludeNames = names: path:
    !(builtins.elem (builtins.baseNameOf path) names);

  # 排除匹配正则模式的（返回 null 表示不匹配）
  excludePattern = pattern: path:
    builtins.match pattern (builtins.baseNameOf path) == null;

  # 仅包含指定名称列表中的
  includeNames = names: path:
    builtins.elem (builtins.baseNameOf path) names;

  # 路径包含特定子字符串
  pathContains = substr: path:
    lib.hasInfix substr (toString path);

  # 组合多个谓词：全部满足 (AND)
  allPredicates = preds: path:
    lib.all (pred: pred path) preds;

  # 组合多个谓词：任一满足 (OR)
  anyPredicate = preds: path:
    lib.any (pred: pred path) preds;

  # 谓词取反 (NOT)
  notPredicate = pred: path:
    !(pred path);

  # ========== 高阶过滤工具 ==========

  # 基础过滤
  filterModules = predicate: paths:
    lib.filter predicate paths;

  # 扫描 + 过滤的管道操作
  scanAndFilter = path: predicate:
    filterModules predicate (scanModules path);

  # ========== 便捷组合 API ==========

  /*
  * 扫描目录并排除指定名称
  * 用法：importExcept ./modules ["test.nix" "legacy"]
  */
  importExcept = path: names:
    scanAndFilter path (excludeNames names);

  /*
  * 扫描目录并仅包含指定名称
  * 用法：importOnly ./modules ["main.nix" "core" "utils.nix"]
  */
  importOnly = path: names:
    scanAndFilter path (includeNames names);

  /*
  * 扫描目录并应用自定义谓词
  * 用法：importWith ./modules (excludePattern "^_.*")
  */
  importWith = path: predicate:
    scanAndFilter path predicate;

  /*
  * 复杂条件组合示例：
  * importComplex = importWith ./modules (allPredicates [
  *   (excludeNames ["test.nix"])
  *   (excludePattern "^_.*")
  *   (pathContains "production")
  * ])
  */
}
