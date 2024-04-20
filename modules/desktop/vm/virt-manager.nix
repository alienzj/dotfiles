{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.vm.virt-manager;
in {
  options.modules.desktop.vm.virt-manager = {
    enable = mkBoolOpt false;
  };

  # ref https://www.youtube.com/watch?v=rCVW8BGnYIc
  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
	  #runAsRoot = false;
          swtpm.enable = true;
	  ovmf = {
            enable = true;

            # https://github.com/NixOS/nixpkgs/issues/164064
	    #package = pkgs.unstable.OVMFFull;
	    #packages = [ pkgs.OVMFFull.fd ];
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                #csmSupport = false;
                httpSupport = true;
                tpmSupport = true;
              }).fd
            ];
          };
	};
      };
      spiceUSBRedirection.enable = true;
    };

    services.spice-vdagentd.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice-gtk
      spice-protocol
      win-virtio
      #win-spice

      # https://github.com/NixOS/nixpkgs/issues/113172
      # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
      # https://www.debugpoint.com/share-folder-virt-manager/
      # https://virtio-fs.gitlab.io/howto-windows.html
      virtiofsd
    ];

    user.extraGroups = [ "libvirtd" ];
  };
}
