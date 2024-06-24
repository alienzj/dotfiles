{
  config,
  lib,
  ...
}:
with builtins;
with lib; let
  blocklist = fetchurl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
in {
  networking.extraHosts = ''
    #192.168.1.1   router.home

    # Hosts
    #${optionalString (config.time.timeZone == "Asia/Hong_Kong") ''
      #    x.x.x.x  eniac.home
      #    y.y.y.y  magic.home
      #  ''}

    # Block garbage
    ${optionalString config.services.xserver.enable (readFile blocklist)}
  '';

  ## Location config -- since Toronto is my 127.0.0.1
  # time.timeZone = mkDefault "America/Toronto";
  time.timeZone = mkDefault "Asia/Hong_Kong";

  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/i18n.nix
  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
    extraLocaleSettings = mkDefault {
      LC_ALL = "en_US.UTF-8";
    };
  };

  # For redshift, mainly
  location =
    if config.time.timeZone == "Asia/Hong_Kong"
    then {
      provider = "manual";
      latitude = 22.43;
      longitude = 114.21;
    }
    else {};

  # TODO
  # So the vaultwarden CLI knows where to find my server.
  #modules.shell.vaultwarden.config.server = "vault.alienzj.tech";
}
