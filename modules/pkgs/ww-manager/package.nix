{
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages.ww-manager = pkgs.python3.pkgs.buildPythonApplication {
      pname = "ww-manager";
      version = "2026-10-27";
      format = "pyproject";

      src = pkgs.fetchFromGitHub {
        owner = "timetetng";
        repo = "wutheringwaves-cli-manager";
        rev = "ce94c2595377dcb0b2221422143e94578601b0e2";
        hash = "sha256-7iM2rEmXpnmnYMzTOHPRn9Tp+oUBx1RXAg+CvLJh/vk=";
      };

      # 依赖
      nativeBuildInputs = with pkgs.python3.pkgs; [
        hatchling
      ];

      propagatedBuildInputs = with pkgs.python3.pkgs; [
        typer
        certifi
        rich
        typing-extensions
        requests
        prompt-toolkit
      ];

      pythonImportsCheck = ["ww_manager"];

      meta = with lib; {
        description = "《鸣潮》命令行 CLI 管理器";
        homepage = "https://github.com/timetetng/wutheringwaves-cli-manager";
        license = licenses.mit;
        mainProgram = "ww";
      };
    };
  };
}
