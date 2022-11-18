{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.samba;
in {
  options.modules.services.samba = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
      networking.firewall.allowedTCPPorts = [
        5357 # wsdd
      ];
      networking.firewall.allowedUDPPorts = [
        3702 # wsdd
      ];

      services.samba = {
        enable = true;
        securityType = "user";
        extraConfig = ''
          workgroup = magic.local
          server string = smbnix
          netbios name = smbnix
          security = user 
          #use sendfile = yes
          #max protocol = smb2
          # note: localhost is the ipv6 localhost ::1
          hosts allow = 10.132.22. 192.168.0. 127.0.0.1 localhost
          hosts deny = 0.0.0.0/0
          guest account = nobody
          map to guest = bad user
        '';
        shares = {
          public = {
            path = "/mnt/store/share/public";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "username";
            "force group" = "groupname";
          };
          private = {
            path = "/mnt/store/share/private";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "username";
            "force group" = "groupname";
          };
        };
      };
    }
  ]);
}
