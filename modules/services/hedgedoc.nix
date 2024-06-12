# reference
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/hedgedoc.nix
## https://wiki.nixos.org/wiki/Hedgedoc
{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.hedgedoc;
in {
  options.modules.services.hedgedoc = {
    enable = mkBoolOpt false; # "activate the hedgeDoc markdown editor service";
    host = mkOption {
      type = with types; nullOr str;
      default = "localhost";
    };
    port = mkOption {
      type = types.port;
      default = 8001;
    };
  };

  config =
    mkIf cfg.enable
    (
      mkMerge [
        {
          services.hedgedoc = {
            enable = true;
            settings = {
              host = cfg.host;
              port = cfg.port;
              ## This is useful if you are trying to run hedgedoc behind a reverse proxy
              #domain = "hedgedoc.example.com";
              ## This is useful if you are trying to run hedgedoc behind a reverse proxy.
              ## Only applied if {option}`domain` is set.
              #protocolUseSSL = true;
              allowGravatar = true;
              allowOrigin = [
                "localhost"
                #"hedgedoc.example.com"
              ];

              db = {
                username = "hedgedoc";
                database = "hedgedoc";
                dialect = "postgres";
                host = "/run/postgresql";
              };
            };

            #environmentFile = "";
          };

          services.postgresql = {
            ensureDatabases = ["hedgedoc"];
            ensureUsers = [
              {
                name = "hedgedoc";
                ensureDBOwnership = true;
                #ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
              }
            ];
          };

          #services.nginx = {
          #  enable = true;

          # Use recommended settings
          #  recommendedGzipSettings = true;
          #  recommendedOptimisation = true;
          #  recommendedProxySettings = true;
          #  recommendedTlsSettings = true;

          #  # Only allow PFS-enabled ciphers with AES256
          #  sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

          #  virtualHosts."hedgedoc.example.com" = {
          #    forceSSL = true;
          #    enableACME = true;
          #    root = "/var/www/hedgedoc";
          #    locations."/".proxyPass = "http://10.132.2.151:8001";
          #    locations."/socket.io/" = {
          #      proxyPass = "http://10.132.2.151:8001";
          #      proxyWebsockets = true;
          #      extraConfig = "proxy_ssl_server_name on;";
          #    };
          #  };
          #};

          networking.firewall.allowedTCPPorts = [cfg.port];
        }
      ]
    );
}
