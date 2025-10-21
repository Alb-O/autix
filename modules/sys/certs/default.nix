{ lib, ... }:
let
  mkEnvVars =
    path:
    lib.mapAttrs (_: value: lib.mkDefault value) {
      CURL_CA_BUNDLE = path;
      GIT_SSL_CAINFO = path;
      NIX_SSL_CERT_FILE = path;
      NODE_EXTRA_CA_CERTS = path;
      REQUESTS_CA_BUNDLE = path;
      SSL_CERT_FILE = path;
    };

  nixosModule =
    { pkgs, lib, ... }:
    let
      bundlePath = "/etc/ssl/certs/ca-bundle.crt";
      envVars = mkEnvVars bundlePath;
    in
    {
      config = {
        environment.systemPackages = [ pkgs.cacert ];
        environment.variables = envVars;
        environment.sessionVariables = envVars;

        nix.settings.ssl-cert-file = lib.mkDefault bundlePath;
      };
    };

  hmModule =
    { pkgs, lib, ... }:
    let
      bundlePath = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      envVars = mkEnvVars bundlePath;
    in
    {
      config = {
        home.packages = [ pkgs.cacert ];
        home.sessionVariables = envVars;

        programs.git.settings.http.sslCAInfo = lib.mkDefault bundlePath;
      };
    };
in
{
  autix.aspects.certificates = {
    description = "Ensure CA certificates are installed and exported consistently.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };
}
