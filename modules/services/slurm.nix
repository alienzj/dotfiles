{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.slurm;
in {
  options.modules.services.slurm = {
    enable = mkBoolOpt false;
    control_machine = "";
    cluster_name = "";
  };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/computing/slurm/slurm.nix
  config = mkIf cfg.enable {
    services.munge = {
      enable = true;
      password = "/etc/munge/munge.key";
    };

    services.slurm = {
      server.enable = true;
      # slurmdbd: error: mysql_real_connect failed: 2002 Can't connect to local server through socket '/run/mysqld/mysqld.sock' (2)
      # May 07 20:14:49 magic slurmdbd-start[1510]: slurmdbd: error: The database must be up when starting the MYSQL plugin.  Trying again in 5 seconds.
      dbdserver.enable = false;
      client.enable = true;
      controlMachine = "magic";
      clusterName = "NixMagIC";
      #nodeName = [ "magic CPUs=8 RealMemory=60000 SocketsPerBoard=1 CoresPerSocket=4 ThreadsPerCore=2 State=UNKNOWN" ];
      #nodeName = [ "magic CPUs=12 RealMemory=120000 SocketsPerBoard=1 CoresPerSocket=6 ThreadsPerCore=2 State=UNKNOWN" ];
      #nodeName = [ "magic CPUs=8 RealMemory=60000 SocketsPerBoard=1 CoresPerSocket=6 ThreadsPerCore=2 State=UNKNOWN" ];
      nodeName = ["magic CPUs=8 State=UNKNOWN"];
      partitionName = ["debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP"];
      enableSrunX11 = false;
      extraPlugstackConfig = ''
        optional ${pkgs.slurm-spank-stunnel}/lib/stunnel.so
      '';
    };

    # homepage: "https://github.com/stanford-rc/slurm-spank-stunnel"
    # description: "Plugin for SLURM for SSH tunneling and port forwarding support"

    #  buildPhase = ''
    #    gcc -I${slurm.dev}/include -shared -fPIC -o stunnel.so slurm-spank-stunnel.c
    #  '';

    # installPhase = ''
    #   mkdir -p $out/lib $out/etc/slurm/plugstack.conf.d
    #   install -m 755 stunnel.so $out/lib
    #   install -m 644 plugstack.conf $out/etc/slurm/plugstack.conf.d/stunnel.conf.example
    # '';
    environment.systemPackages = [pkgs.slurm-spank-stunnel];
  };
}
