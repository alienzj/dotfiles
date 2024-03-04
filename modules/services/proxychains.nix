{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.proxychains;
    opts = {
      type = cfg.type;
      host = cfg.host;
      port = cfg.port;
    };
in {
  options.modules.services.proxychains = {
    enable = mkBoolOpt false;
    type = mkOption {
      type = types.str;
      default = "socks5";
      description = lib mkDoc ''
        Proxy type,  one of “http”, “socks4”, “socks5”
      '';
    };
    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib mkDoc ''
        Proxy host or IP address.
      '';
    };
    port = mkOption {
      type = types.port;
      default = 1080;
      description = lib mkDoc ''
        Proxy port
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.proxychains = {
      enable = true;
      package = pkgs.proxychains-ng;
      proxies = {
        pacman = {
          enable = true;
          type = cfg.type;
	  host = cfg.host;
	  port = cfg.port;
        };
      };
    };
  };
}
