{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with builtins;
with lib;
with hey.lib; let
  cfg = config.modules.services.nginx;
in {
  options.modules.services.nginx = {
    enable = mkBoolOpt false;
    enableCloudflareSupport = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [80 443];

      user.extraGroups = ["nginx"];

      services.nginx = {
        enable = true;

        # Use recommended settings
        statusPage = true;
        recommendedBrotliSettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedZstdSettings = true;

        # Reduce the permitted size of client requests, to reduce the likelihood
        # of buffer overflow attacks. This can be tweaked on a per-vhost basis,
        # as needed.
        clientMaxBodySize = "256k"; # default 10m
        # Significantly speed up regex matchers
        appendConfig = ''pcre_jit on;'';

        # Nginx sends all the access logs to /var/log/nginx/access.log by default.
        # instead of going to the journal!
        # commonHttpConfig = "access_log syslog:server=unix:/dev/log;";

        commonHttpConfig = ''
          client_body_buffer_size  4k;       # default: 8k
          large_client_header_buffers 2 4k;  # default: 4 8k

          map $sent_http_content_type $expires {
              default                    off;
              text/html                  10m;
              text/css                   max;
              application/javascript     max;
              application/pdf            max;
              ~image/                    max;
          }
        '';

        #resolver.addresses = let
        #  isIPv6 = addr: builtins.match ".*:.*:.*" addr != null;
        #  escapeIPv6 = addr:
        #    if isIPv6 addr
        #    then "[${addr}]"
        #    else addr;
        #  cloudflare = ["1.1.1.1" "2606:4700:4700::1111"];
        #  resolvers =
        #    if config.networking.nameservers == []
        #    then cloudflare
        #    else config.networking.nameservers;
        #in
        #  map escapeIPv6 resolvers;

        sslDhparam = config.security.dhparams.params.nginx.path;
      };

      security.dhparams = {
        enable = true;
        params.nginx = {};
      };
    })

    (mkIf cfg.enableCloudflareSupport {
      services.nginx.commonHttpConfig = ''
        ${concatMapStrings (ip: "set_real_ip_from ${ip};\n")
          (filter (line: line != "")
            (splitString "\n" ''
              ${readFile (fetchurl "https://www.cloudflare.com/ips-v4/")}
              ${readFile (fetchurl "https://www.cloudflare.com/ips-v6/")}
            ''))}
        real_ip_header CF-Connecting-IP;
      '';
    })
  ];
}
# Helpful nginx snippets
#
# Set expires headers for static files and turn off logging.
#   location ~* ^.+\.(js|css|swf|xml|txt|ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|r ss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav |bmp|rtf)$ {
#     access_log off; log_not_found off; expires 30d;
#   }
#
# Deny all attempts to access PHP Files in the uploads directory
#   location ~* /(?:uploads|files)/.*\.php$ {
#     deny all;
#   }

