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
      then [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJ92xO04Yww0AcQ7hEmo5a1vaNm0pBdD9U80OKPztfv jiezhu@magic_pc 20240516"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvPPsoS8zruy3kxqmCZjE1Zhu2vProXCP755UKGqhyA jiezhu@magic_dev 20240516"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjLz52kR1atxbLWFJUE4M2UigRSxev08BRb7132tXOT jiezhu@magic-server 20240516"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAe+TIA9tl5zFTGzHz7fuXeh9xVjCVHlDUn816UT6eB2 alienzj@eniac 20240516"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID38KtdBdF8G1Vv9cMwR9cjcYaA85VFbfrZpfoQdlPfg alienzj@yoga 20240516"
      ]
      else [];

    user.packages = with pkgs;
    (if cfg.sshx.enable then [
      unstable.sshx
      unstable.sshx-server
    ] else []);

  };
}
