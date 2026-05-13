/**
* conform.nvim - formatter plugin
*
* Home Page: https://github.com/stevearc/conform.nvim
*/
{
  lib,
  pkgs,
  ...
}: let
  # formatter 工具声明
  fmtDefs = {
    shellcheck = {pkg = pkgs.shellcheck;};
    shellharden = {pkg = pkgs.shellharden;};
    shfmt = {pkg = pkgs.shfmt;};
    clang-format = {
      pkg = pkgs.clang-tools;
      exe = "clang-format";
    };
    ruff = {pkg = pkgs.ruff;};
    prettierd = {pkg = pkgs.prettierd;};
    prettier = {
      pkg = pkgs.prettier;
      exe = "prettier";
    };
    squeeze_blanks = {
      pkg = pkgs.coreutils;
      exe = "cat";
    };
  };

  # 文件类型映射
  ftFormatters = {
    bash = ["shellcheck" "shellharden" "shfmt"];
    cpp = ["clang-format"];
    python = ["ruff"];
    javascript = {
      __unkeyed-1 = "prettierd";
      __unkeyed-2 = "prettier";
      timeout_ms = 2000;
      stop_after_first = true;
    };

    # trim_whitespace / trim_newlines 由 conform 内置，无需在 fmtDefs 中声明
    "_" = ["squeeze_blanks" "trim_whitespace" "trim_newlines"];
  };

  # 生成 conform.formatters
  mkFormatter = name: {
    pkg,
    exe ? name,
  }: {
    command = lib.getExe' pkg exe;
  };
in {
  # 提取所有包注入环境
  home.packages = lib.mapAttrsToList (_: v: v.pkg) fmtDefs;

  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;

      lazyLoad.settings = {
        event = "BufWritePre";
        cmd = "ConformInfo";
        keys = [
          {
            __unkeyed-1 = "<leader>cf";
            __unkeyed-3.__raw = ''
              function()
                require("conform").format({ async = true })
              end
            '';
            desc = "Format buffer";
          }
        ];
      };

      settings = {
        formatters_by_ft = ftFormatters;
        formatters = lib.mapAttrs mkFormatter fmtDefs;
      };
    };
  };
}
