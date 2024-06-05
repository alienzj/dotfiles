{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.stalwart-mail;
in {
  options.modules.services.stalwart-mail = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.stalwart-mail = {
      enable = true;
      settings = {
        server.hostname = "localhost";
	server.service_addr = ":1234";
	server.domain = "localhost";
	#server.certificate = "default";
	server.max-connections = 128;
	server.imap = {
          server = "localhost";
          port = 993;
          starttls = true;
        };
        server.smtp = {
          server = "localhost";
          port = 465;
          starttls = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 25 465 587 993 1234 ];
  };
}
