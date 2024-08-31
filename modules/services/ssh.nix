{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Ensure this directory exists and has correct permissions.
    systemd.user.tmpfiles.rules = ["d %h/.config/ssh 700 - - - -"];

    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        # Require keys over passwords. Ensure target machines are provisioned
        # with authorizedKeys!
        PasswordAuthentication = false;
      };
      # Suppress superfluous TCP traffic on new connections. Undo if using SSSD.
      extraConfig = ''GSSAPIAuthentication no'';
      # Deactivate short moduli
      moduliFile = pkgs.runCommand "filterModuliFile" {} ''
        awk '$5 >= 3071' "${config.programs.ssh.package}/etc/ssh/moduli" >"$out"
      '';
      # Removes the default RSA key (not that it represents a vulnerability, per
      # se, but is one less key (that I don't plan to use) to the castle laying
      # around) and ensures the ed25519 key is generated with 100 rounds, rather
      # than the default (16), to improve its entropy.
      hostKeys = [
        {
          comment = "${config.networking.hostName}.local";
          path = "/etc/ssh/ssh_host_ed25519_key";
          rounds = 100;
          type = "ed25519";
        }
      ];
    };

    #user.openssh.authorizedKeys.keys =
    #  if config.user.name == "alienzj"
    #  then [
    #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJ92xO04Yww0AcQ7hEmo5a1vaNm0pBdD9U80OKPztfv jiezhu@magic_pc 20240516"
    #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvPPsoS8zruy3kxqmCZjE1Zhu2vProXCP755UKGqhyA jiezhu@magic_dev 20240516"
    #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjLz52kR1atxbLWFJUE4M2UigRSxev08BRb7132tXOT jiezhu@magic-server 20240516"
    #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAe+TIA9tl5zFTGzHz7fuXeh9xVjCVHlDUn816UT6eB2 alienzj@eniac 20240516"
    #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID38KtdBdF8G1Vv9cMwR9cjcYaA85VFbfrZpfoQdlPfg alienzj@yoga 20240516"
    #  ]
    #  else [];
  };
}
