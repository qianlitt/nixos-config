{
  flake.factory.i18n = {lang ? "en"}: {lib, ...}: let
    locale =
      {
        en = "en_US.UTF-8";
        zh = "zh_CN.UTF-8";
      }.${
        lang
      } or (throw "Unsupported language: ${lang}");

    localeCategories = [
      "ADDRESS"
      "IDENTIFICATION"
      "MEASUREMENT"
      "MONETARY"
      "NAME"
      "NUMERIC"
      "PAPER"
      "TELEPHONE"
      "TIME"
    ];
  in {
    i18n = {
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];

      defaultLocale = lib.mkDefault locale;

      extraLocales = [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];

      extraLocaleSettings = lib.mkDefault (
        lib.genAttrs
        (map (name: "LC_${name}") localeCategories)
        (_: locale)
      );
    };
  };
}
