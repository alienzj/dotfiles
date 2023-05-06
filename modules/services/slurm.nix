{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.slurm;
in {
  options.modules.services.slurm = {
    enable = mkBoolOpt false;
  };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/computing/slurm/slurm.nix

  config = mkIf cfg.enable {
    services.munge = {
      enable = true;
      password = "/etc/munge/munge.key";
    };

    services.slurm = {
      server.enable = true;
      dbdserver.enable = true;
      client.enable = true;
      controlMachine = "magic";
      clusterName = "NixMagIC";
      nodeName = [ "magic CPUs=4 State=UNKNOWN" ];
      partitionName = [ "debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP" ];
    };
  };
}
