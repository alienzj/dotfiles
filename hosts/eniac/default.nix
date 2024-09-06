# eniac -- my primary powerhouse
## CPU: AMD Ryzen 7 1700X (16) @ 3.400GHz
## GPU: NVIDIA GeForce GTX 1080 Ti
{
  hey,
  lib,
  ...
}:
with lib;
with builtins; {
  system = "x86_64-linux";

  modules = {
    theme.active = "autumnal";
    xdg.ssh.enable = true;

    profiles = {
      role = "workstation";
      user = "alienzj";
      networks = ["sz"];
      hardware = [
        "cpu/amd"
        "gpu/nvidia"
        "audio"
        "audio/realtime"
        "hidpi"
        "ssd"
      ];
    };

    desktop = {
      # X only
      # bspwm.enable = true;
      # term.default = "xst";
      # term.st.enable = "true";

      # Wayland only
      hyprland = rec {
        enable = true;
        monitors = [
          {
            output = "HDMI-0";
            position = "3840x2160";
            primary = true;
          }
          #{ output = "DP-3";
          #  position = "0x2191"; }
          #{ output = "DP-2";
          #  position = "4480x2191"; }
          #{ output = "HDMI-A-1";
          #  mode = "3840x2160@120";
          #  position = "1280x0"; }
        ];

        extraConfig = ''
          # REVIEW: Might be a hyprland bug, but an "Unknown-1" display is
          #   always created and reserves some desktop space, so I disable it.
          monitor = Unknown-1,disable

          # Bind fixed workspaces to external monitors
          ##workspace = name:left, monitor:DP-3, default:true
          ##workspace = name:right, monitor:DP-2, default:true
          ##workspace = name:tv, monitor:HDMI-A-1, default:true, gapsout:4

          # Scroll by holding down a side button, because the wheel is broken
          ##device {
          ##    name = mosart-semi.-2.4g-wireless-mouse
          ##    scroll_method = on_button_down
          ##    scroll_button = 276
          ##}

          ##exec-once = hyprctl keyword monitor HDMI-A-1,disable
        '';
      };

      term.default = "foot";
      term.foot.enable = true;
      term.wezterm.enable = true;

      # Extra
      apps = {
        rofi.enable = true;
        filezilla.enable = true;
        geph.enable = true;
        godot.enable = true;
        goldendict.enable = true;
        libreoffice.enable = true;
        wpsoffice.enable = true;
        zoomus.enable = true;
        rustdesk.enable = true;
        #teamviewer.enable = true;
        #rdp.enable = true;
        #net.enable = true;
        scrcpy.enable = true;
        thunar.enable = true;
        #thunderbird.enable = true;
        transmission.enable = true;
        #ue.enable = true;
        #unity3d.enable = true;
      };

      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        chromium.enable = true;
        #qutebrowser.enable = true;
      };

      gaming = {
        steam = {
          enable = true;
          #libraryDir = "/mnt/store/games/steam";
          #libraryDir = "/media/windows/Program Files (x86)/Steam";
        };
        #emulators = {
        #psx.enable = true;
        #ds.enable = true;
        #gb.enable = false;
        #gba.enable = false;
        #snes.enable = false;
        #};
        #games.enable = true;
      };

      media = {
        doc = {
          enable = true;
          pdf.enable = true;
          ebook.enable = true;
        };
        cad.enable = true;
        daw.enable = true;
        audio.enable = true;
        video = {
          enable = true;
          capture.enable = true;
          editor.enable = true;
          player.enable = true;
          tools.enable = true;
        };
        graphics = {
          enable = true;
          tools.enable = true;
          raster.enable = true;
          vector.enable = true;
          sprites.enable = true;
          design.enable = true;
        };
      };

      im = {
        matrix.enable = true;
        tdesktop.enable = true;
        slack.enable = true;
        discord.enable = true;
        qqwechat.enable = true;
      };

      vm = {
        #osx.enable = true;
        virt-manager.enable = true;
        virtualbox.enable = true;
      };

      input.fcitx5.enable = true;
      noter.zotero.enable = true;
    };

    science = {
      ds.enable = true;
      ai.enable = true;
      cytoscape.enable = true;
      bioinfo.enable = true;
      #math = {
      #  enable = true;
      #  tools.enable = true;
      #  wolframengine.enable = false;
      #  mathematica.enable = false;
      #  matlab.enable = true;
      #};
    };

    dev = {
      cc.enable = true;
      lua.enable = true;
      node = {
        enable = true;
        xdg.enable = true;
      };
      rust = {
        enable = true;
        xdg.enable = true;
      };
      python = {
        enable = true;
        xdg.enable = true;
      };
      shell = {
        enable = true;
        xdg.enable = true;
      };
      scala = {
        enable = true;
        xdg.enable = true;
      };
      r.enable = true;
      julia.enable = true;
      go.enable = true;
      haskell.enable = true;
      zeal.enable = true;
      conda = {
        enable = true;
        installationPath = "/home/alienzj/.conda/envs/env-base";
        extraPkgs = [pkgs.gcc];
      };
      mamba = {
        enable = true;
        mambaRootPrefix = "/home/alienzj/.mamba";
        extraPkgs = [pkgs.gcc];
      };
      ruby.enable = true;
      web.enable = true;
      php.enable = true;
      janet.enable = true;
      zig.enable = true;
    };

    editors = {
      default = "nvim";
      emacs = rec {
        enable = true;
        #doom = {
        #  enable = false;
        #  forgeUrl = "https://github.com";
        #  repoUrl = "https://github.com/doomemacs/doomemacs";
        #  configRepoUrl = "https://github.com/alienzj/doom.d";
        #};
      };
      vim.enable = true;
      vscode.enable = true;
      #vscodium.enable = true;
      rstudio.enable = true;
      android-studio.enable = true;
    };

    shell = {
      #vaultwarden.enable = true;
      #pass.enable = true;
      #adl.enable = true;
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      #zellij.enable = true;
      zsh.enable = true;
      fish.enable = true;
    };

    services = {
      adb.enable = true; # android
      syncthing.enable = true;
      rstudio-server.enable = true;
      jupyterhub = {
        enable = true;
        adminUser = "alienzj";
        allowedUser = ["alienzj"];
      };
      ssh.enable = true;
      docker.enable = true;
      # Needed occasionally to help the parental units with PC problems
      #rdp.enable = true; # remote desktop
      #samba.enable = true; # share folders
      #printing.enable = true;
      #lockscreen = {
      #  enable = true;
      #  inactiveInterval = 10;
      #};
      flameshot = {
        enable = true;
        savePath = "/home/alienzj/pictures/flameshot";
      };
      #transmission.enable = true;
      proxychains = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 1080;
      };
      shadowsocks-client-pacman = {
        enable = true;
        remotePort = 5777;
        localAddress = "127.0.0.1";
        localPort = 1080;
        remoteAddressFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/server_pacman";
        passwordFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/password_pacman";
        encryptionMethod = "chacha20-ietf-poly1305";
      };
      rathole-client-pacman = {
        enable = true;
        configFile = "/home/alienzj/toolkits/ohconfig/rathole/pacman_eniac_c.toml";
      };
      #boinc.enable = true;
      #slurm.enable = true;
      earlyoom.enable = true;
      #home-assistant.enable = true;
      #onedrive.enable = true;
    };

    system = {
      utils.enable = true;
      fs.enable = true;
    };

    virt.qemu.enable = true;
  };

  ## local config
  config = {pkgs, ...}: {
    #networking.search = ["home.alienzj.tech"];

    # Low-latency audio for guitar recording and DAW stuff. Should not be
    # generalized, since these values depend heavily on many local factors, like
    # CPU speed, kernels, audio cards, etc.
    services.pipewire.extraConfig.pipewire."95-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 64;
      };
    };

    user.packages = with pkgs; [
      #unstable.guitarix
      #gxplugins-lv2
      #ladspaPlugins

      signal-desktop
    ];

    ## Local config
    #services.pcscd.enable = true; # for gpg-agent
    #services.timesyncd.enable = true; # to sync time

    # Run unpatched dynamic binaries on NixOS
    programs.nix-ld.enable = true;

    ## Security
    #security.acme.defaults.email = "alienchuj@gmail.com";
  };

  hardware = {...}: {
    # Kernel
    ##boot = {
    ##  initrd.availableKernelModules = [
    ##    "xhci_pci"
    ##    "vfio-pci"
    ##    "ahci"
    ##    "nvme"
    ##    "usbhid"
    ##    "usb_storage"
    ##    "sd_mod"
    ##    "sr_mod"
    ##  ];
    ##  initrd.kernelModules = [];
    ##  kernelModules = [
    ##    "tun"
    ##    "vfio"
    ##    "vfio_immmu_type1"
    ##    "virtio"
    ##    "vfio_pci"
    ##    "kvm-amd"
    ##    "acpi_call"
    ##  ];

    ##  kernelParams = [
    ##    # didn't work
    ##    #"usb.core.autosuspend=-1" # disable autosuspend
    ##    #"usb.core.autosuspend=3600"  # 5 sencond # it seems no effect
    ##  ];
    ##
    ##  extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    ##
    ##  extraModprobeConfig = lib.mkMerge [
    ##    "options kvm_amd nested=1"
    ##    "options kvm_amd emulate_invalid_guest_state=0"
    ##    "options kvm ignore_msrs=1"
    ##    # idle audio card after one second
    ##    #"options snd_hda_amd power_save=1"
    ##    # enable wifi power saving (keep uapsd off to maintain low latencies)
    ##    #"options iwlwifi power_save=1 uapsd_disable=1"
    ##  ];
    ##};

    boot.supportedFilesystems = ["ntfs"];

    #networking.interfaces.eno1.useDHCP = true;

    # CPU
    ##nix.settings = {
    ##  cores = lib.mkDefault 12;
    ##  max-jobs = lib.mkDefault 8;
    ##};

    # Disable all USB wakeup events to ensure restful sleep. This system has
    # many peripherals attached to it (shared between Windows and Linux) that
    # can unpredictably wake it otherwise.
    systemd.services.fixSuspend = {
      script = ''
        for ev in $(grep enabled /proc/acpi/wakeup | cut --delimiter=\  --fields=1); do
            echo $ev > /proc/acpi/wakeup
        done
      '';
      wantedBy = ["multi-user.target"];
    };

    #services.udev.extraRules = ''
    #  # keyboard autosuspand
    #  ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend}="-1"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/control}="on"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend_delay_ms}="3600000"

    #  # mouse autosuspand
    #  ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend}="-1"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/control}="on"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend_delay_ms}="3600000"
    #'';

    # Displays
    ##services.xserver = {
    ##  enable = true;
    ##  exportConfiguration = true;
    ##  xkb.layout = "us";
    ##  serverFlagsSection = ''
    ##    Option "StandbyTime" "20"
    ##    Option "SuspendTime" "30"
    ##    Option "OffTime" "45"
    ##    Option "BlankTime" "45"
    ##  '';
    ##};

    ## Single monitor
    ## https://github.com/NixOS/nixpkgs/issues/30796
    ##services.xserver.displayManager.setupCommands = ''
    ##  ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output HDMI-0 --mode 3840x2160 --rate 60 --pos 0x0 --primary
    ##'';

    # Mouse
    #services.libinput = {
    #  enable = true;
    #  mouse.accelProfile = "flat";
    #};

    # Filesystem
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime" "errors=remount-ro"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
      options = ["noatime"];
    };

    fileSystems."/mnt/store" = {
      device = "/dev/disk/by-label/store";
      fsType = "ext4";
    };

    swapDevices = [{device = "/dev/disk/by-label/swap";}];

    ## Filesystem
    #fileSystems."/" = {
    #  device = "/dev/disk/by-uuid/952cf267-a657-4abb-b121-5bebf3a103aa";
    #  fsType = "ext4";
    #};

    #fileSystems."/boot" = {
    #  device = "/dev/disk/by-uuid/C247-75AF";
    #  fsType = "vfat";
    #};

    #fileSystems."/home" = {
    #  device = "/dev/disk/by-uuid/0dcf7734-5d12-4b60-8632-6a75196a31a7";
    #  fsType = "ext4";
    #};

    #fileSystems."/mnt/store" = {
    #  device = "/dev/disk/by-uuid/294a32c8-a7ab-4646-86c4-277dafc708b7";
    #  fsType = "ext4";
    #};

    #swapDevices = [{device = "/dev/disk/by-uuid/e7e56401-3b27-4cb8-852b-9cc971f63512";}];

    # Hibernation
    ## Hibernation requires a configured swap device.
    ## go to hibernation by running: systemctl hibernate
    boot.resumeDevice = "/dev/disk/by-label/swap";

    ## Go into hibernate after specific suspend time
    ## system will go from suspend into hibernate after 1 hour
    #systemd.sleep.extraConfig = ''
    #  HibernateDelaySec=1h
    #'';

    # power management
    #power = {
    #  enable = true;
    #  pm.enable = true;
    #  pc.enable = true;
    #  cpuFreqGovernor = "performance";
    #  resumeDevice = "/dev/disk/by-uuid/e7e56401-3b27-4cb8-852b-9cc971f63512";
    #};

    # network management
    #network = {
    #  enable = true;
    #  networkd.enable = true;
    #  MACAddress = "10:7b:44:8e:fe:b4";
    #  IPAddress = ["192.168.1.2/24"];
    #  RouteGateway = ["192.168.1.1"];
    #  DomainNameServer = ["223.5.5.5" "8.8.8.8" "119.29.29.29"];
    #  NetworkTimeServer = ["ntp7.aliyun.com" "ntp.aliyun.com"];
    #};
  };
}
