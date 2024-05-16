{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
    sshx.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = true;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "no";
      settings.X11Forwarding = false;
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "dumbledore"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJyw1sOglPfJkgBRNuPu0U0ICfGEuyQ0H/Es3Lt/fp/ alienzj@magic" ]
      else [];

    user.packages = with pkgs;
    (if cfg.sshx.enable then [
      unstable.sshx
      unstable.sshx-server
    ] else []);

  };
}
