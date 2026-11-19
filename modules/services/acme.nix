{
  flake.factory = let
    # 所有验证方式的专属参数
    challengeArgs = [
      "dnsProvider"
      "webroot"
      "listenHTTP"
      "s3Bucket"
    ];

    mkAcmeCert = method: {
      name ? domain,
      domain,
      ...
    } @ args: let
      # 排除当前验证方式之外的专属参数
      forbidden =
        builtins.filter
        (arg: arg != method)
        challengeArgs;

      conflicts =
        builtins.filter
        (arg: builtins.hasAttr arg args)
        forbidden;
    in
      if !(builtins.hasAttr method args)
      then throw "acme: missing required parameter '${method}'"
      else if conflicts != []
      then throw "acme: incompatible parameters: ${builtins.concatStringsSep ", " conflicts}"
      else {
        ${name} = builtins.removeAttrs args ["name"];
      };
  in {
    acme = certs: {
      imports = map (cert: {security.acme.certs = cert;}) certs;

      security.acme.acceptTerms = true;
    };

    # DNS-01
    acmeDns = mkAcmeCert "dnsProvider";

    # HTTP-01: Webroot
    acmeWebroot = mkAcmeCert "webroot";

    # HTTP-01: Listen HTTP
    acmeListenHttp = mkAcmeCert "listenHTTP";

    # HTTP-01: S3
    acmeS3 = mkAcmeCert "s3Bucket";
  };
}
