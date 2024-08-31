{
  hey,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.profiles;
  username = cfg.user;
  role = cfg.role;
in
  mkIf (username == "alienzj") (mkMerge [
    {
      user.name = username;
      user.description = "Jie";
      i18n.defaultLocale = mkDefault "en_US.UTF-8";
      modules.shell.vaultwarden.settings.server = "vault.home.alienzj.tech";

      # Be slightly more restrictive about SSH access to workstations, which I
      # only need LAN access to, if ever. Other systems, particularly servers, are
      # remoted into often, so I leave their access control to an upstream router
      # or local firewall.
      user.openssh.authorizedKeys.keys = [
        (let
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYLgH4hnkuyh+cEyoRIlAYbJ4HJYyUKPmajH190zHBQ alienzj";
        in
          if role == "workstation"
          then ''from="10.0.0.0/8" ${key} ${username}''
          else key)
      ];
    }
  ])
