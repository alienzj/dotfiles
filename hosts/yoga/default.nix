{ pkgs, config, lib, ... }:
{
  imports = [
    #<nixos-hardware/lenovo/yoga/6/13ALC6>
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = true;
      apps = {
        rofi.enable = true;
	skype.enable = true;
	zoomus.enable = true;
	#teams.enable = true;
	libreoffice.enable = true;
	wpsoffice.enable = true;
	onlyoffice.enable = true;
	usbimager.enable = true;
        godot.enable = true;
	transmission.enable = true;
	filezilla.enable = true;
	scrcpy.enable = true;
	thunderbird.enable = true;
	anydesk.enable = true;
	rustdesk.enable = false;
	ventoy.enable = true;
	#unetbootin.enable = true;
	etcher.enable = false; 
	authenticator.enable = true;
	backups.enable = true;
	khronos.enable = true;
	solanum.enable = true;
	suckit.enable = true;
	#cryptowatch.enable = true;
	geph.enable = true;
	netapplet.enable = true;
	synology-drive-client.enable = true;
	vpn.enable = true;
	file-manager.enable = true;
	rdp.enable = true;
	sniffnet.enable = true;
      };
      browsers = {
        default = "firefox";
        brave.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
	chromium.enable = true;
      };
      gaming = {
        steam.enable = true;
	emulators = {
	  #psx.enable = true;
	  ds.enable = true;
	  gb.enable = false;
	  gba.enable = false;
	  snes.enable = false;
	};
	games.enable = true;
      };
      media = {
        daw.enable = true;
        documents = {
	  enable = true;
	  pdf.enable = true;
	  ebook.enable = true;
	  file.enable = true;
	};
        graphics.enable = true;
        mpv.enable = true;
	vlc.enable = true;
	youtube-tui.enable = true;
        recording.enable = true;
        spotify.enable = true;
	sayonara.enable = true;
	podcasts.enable = true;
	shortwave.enable = true;
	amberol.enable = true;
	cozy.enable = true;
	netease-cloud-music.enable = true;
      };
      term = {
        default = "xst";
        st.enable = true;
	wezterm.enable = true;
	nnn.enable = true;
      };
      vm = {
        lxd.enable = true;
        qemu.enable = true;
	virtualbox.enable = true;
	virt-manager.enable = true;
	osx.enable = true;
      };
      noter = {
	zotero.enable = true;
	notion.enable = true;
	xournalpp.enable = true;
      };
      reader = {
	newsflash.enable = true;
	wike.enable = true;
      };
      logger = {
	qjournalctl.enable = true;
      };
      im = {
        matrix.enable = true;
	tdesktop.enable = true;
	whatsapp.enable = true;
	slack.enable = true;
	discord.enable = true;
      };
      input = {
        fcitx5.enable = true;
	translate.enable = true;
      };
    };
    science = {
      ai.enable = true;
      cytoscape.enable = true;
      bioinfo.enable = true;
      math = {
        enable = true;
        tools.enable = true;
	mathematica.enable = false;
	matlab.enable = true;
      };
    };
    dev = {
      cc = {
        enable = true;
	xdg.enable = true;
      };
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
      zeal.enable = true;
      r.enable = true;
      conda.enable = true;
      mamba.enable = true;
      julia.enable = true;
      go.enable = true;
      ruby.enable = true;
      web.enable = true;
      haskell.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = rec {
        enable = true;
	doom = {
          enable = true;
	  forgeUrl = "https://github.com";
	  repoUrl = "https://github.com/doomemacs/doomemacs";
	  configRepoUrl = "https://github.com/alienzj/doom.d";
	};
      };
      vim.enable = true;
      vscode_fhs.enable = true;
      #vscode.enable = true;
      vscodium.enable = false;
      rstudio.enable = true;
      rstudio-server.enable = false;
      pycharm.enable = true;
      idea.enable = true;
      rustrover.enable = true;
      clion.enable = false;
      datagrip.enable = true;
      dataspell.enable = true;
      gateway.enable = true;
      goland.enable = true;
      mps.enable = true;
      android-studio.enable = true;
      gaphor.enable = false;
      #textpieces.enable = true;
    };
    shell = {
      adl.enable = true;
      vaultwarden.enable = true;
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      tmux.enable   = true;
      zsh.enable    = true;
      fish.enable    = true;
      zellij.enable = true;
    };
    services = {
      adb.enable = true; # android
      #calibre.enable = true;
      syncthing.enable = true;
      ssh.enable = true;
      docker.enable = true;
      # Needed occasionally to help the parental units with PC problems
      teamviewer.enable = false;
      rdp.enable = false; # remote desktop
      samba.enable = false; # share folders
      printing.enable = false; # RICOH printer
      lockscreen = {
        enable = true;
      	#inactiveInterval = 10;
      };
      flameshot.enable = true;
      #transmission.enable = true;
      shadowsocks-client-pacman = {
      	enable = true;
        remotePort = 5777;
        localAddress = "127.0.0.1";
        localPort = 1080;
        remoteAddressFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/server_pacman";
        passwordFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/password_pacman";
        encryptionMethod = "chacha20-ietf-poly1305";
      };
      #shadowsocks-client-superman = {
      #	 enable = true;
      #  remotePort = 33807;
      #  localAddress = "127.0.0.1";
      #  localPort = 1081;
      #  remoteAddressFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/server_superman";
      #  passwordFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/password_superman";
      #  encryptionMethod = "chacha20-ietf-poly1305";
      #};
      #shadowsocks-client-awsman = {
      #	enable = true;
      #  remotePort = 9391;
      #  localAddress = "127.0.0.1";
      #  localPort = 1082;
      #  remoteAddressFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/server_awsman";
      #  passwordFile = "/home/alienzj/toolkits/ohconfig/shadowsocks/password_awsman";
      #  encryptionMethod = "chacha20-ietf-poly1305";
      #};
 
      rathole-client-pacman = {
        enable = true;
	configFile = "/home/alienzj/toolkits/ohconfig/rathole/pacman_yoga_c.toml";
      };
      #rathole-client-superman = {
      #  enable = true;
      #	 configFile = "/home/alienzj/toolkits/ohconfig/rathole/superman_yoga_c.toml";
      #};
      rathole-client-awsman = {
        enable = true;
	configFile = "/home/alienzj/toolkits/ohconfig/rathole/awsman_yoga_c.toml";
      };

      boinc.enable = false;
      slurm.enable = false;
      earlyoom.enable = true;
      home-assistant.enable = false;
      onedrive.enable = false;
   };
    utils = {
      htop.enable = true;
      neofetch.enable = true;
      pandoc.enable = true;
      ghostscript.enable = true;
      disk.enable = true;
      youdl.enable = true;
    };
    theme.active = "alucard";
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  ## Personal backups
  # Syncthing is a bit heavy handed for my needs, so rsync to my NAS instead.
  #systemd = {
  #  services.backups = {
  #    description = "Backup /usr/store to NAS";
  #    wants = [ "usr-drive.mount" ];
  #    path  = [ pkgs.rsync ];
  #    environment = {
  #      SRC_DIR  = "/usr/store";
  #      DEST_DIR = "/usr/drive";
  #    };
  #    script = ''
  #      rcp() {
  #        if [[ -d "$1" && -d "$2" ]]; then
  #          echo "---- BACKUPING UP $1 TO $2 ----"
  #          rsync -rlptPJ --chmod=go= --delete --delete-after \
  #              --exclude=lost+found/ \
  #              --exclude=@eaDir/ \
  #              --include=.git/ \
  #              --filter=':- .gitignore' \
  #              --filter=':- $XDG_CONFIG_HOME/git/ignore' \
  #              "$1" "$2"
  #        fi
  #      }
  #      rcp "$HOME/projects/" "$DEST_DIR/projects"
  #      rcp "$SRC_DIR/" "$DEST_DIR"
  #    '';
  #    serviceConfig = {
  #      Type = "oneshot";
  #      Nice = 19;
  #      IOSchedulingClass = "idle";
  #      User = config.user.name;
  #      Group = config.user.group;
  #    };
  #  };
  #  timers.backups = {
  #    wantedBy = [ "timers.target" ];
  #    partOf = [ "backups.service" ];
  #    timerConfig.OnCalendar = "*-*-* 00,12:00:00";
  #    timerConfig.Persistent = true;
  #  };
  #};

  time.timeZone = "Asia/Hong_Kong";

  programs.adb.enable = true;
}
