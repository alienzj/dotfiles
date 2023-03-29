{ pkgs, config, lib, ... }:
{
  imports = [
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
	teams.enable = true;
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
	#rustdesk.enable = true;
	ventoy.enable = true;
	#unetbootin.enable = true;
	etcher.enable = true;
	authenticator.enable = true;
	backups.enable = true;
	khronos.enable = true;
	solanum.enable = true;
	suckit.enable = true;
	netapplet.enable = true;
	#geph.enable = true;
	synology-drive-client.enable = true;
	cryptowatch.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      gaming = {
        steam.enable = true;
        emulators = {
	  #psx.enable = true;
	  ds.enable = true;
	  gb.enable = true;
	  gba.enable = true;
	  snes.enable = true;
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
	wezterm = {
	  enable = true;
	  extraConfig = ''

            -- Your lua code / config here
            -- local mylib = require 'mylib';

            -- The filled in variant of the < symbol
            local SOLID_LEFT_ARROW = utf8.char(0xe0b2);

            -- The filled in variant of the > symbol
            local SOLID_RIGHT_ARROW = utf8.char(0xe0b0);

            return {
              -- usemylib = mylib.do_fun();
              font = wezterm.font("JetBrains Mono"),
              font_size = 20.0,
              color_scheme = "myCoolTheme",
	      -- color_scheme = "Doom One",
	      -- color_scheme = "Darcula",
	      -- color_scheme = "MaterialDark",
              hide_tab_bar_if_only_one_tab = true,
	      tab_max_width = 25,
	      -- tab_bar_at_bottom = true,
              use_fancy_tab_bar = false,
              tab_bar_style = {
                active_tab_left = wezterm.format {
                  { Background = { Color = '#0b0022' } },
                  { Foreground = { Color = '#2b2042' } },
                  { Text = SOLID_LEFT_ARROW },
                },
                active_tab_right = wezterm.format {
                  { Background = { Color = '#0b0022' } },
                  { Foreground = { Color = '#2b2042' } },
                  { Text = SOLID_RIGHT_ARROW },
                },
	        inactive_tab_left = wezterm.format {
		  { Background = { Color = '#0b0022' } },
		  { Foreground = { Color = '#1b1032' } },
		  { Text = SOLID_LEFT_ARROW },
		},
		inactive_tab_right = wezterm.format {
		  { Background = { Color = '#0b0022' } },
		  { Foreground = { Color = '#1b1032' } },
		  { Text = SOLID_RIGHT_ARROW },
		},
	      },
	      -- default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
              keys = {
                {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
              }
            }
          '';
          colorSchemes = {
            myCoolTheme = {
              ansi = [
              "#222222" "#D14949" "#48874F" "#AFA75A"
              "#599797" "#8F6089" "#5C9FA8" "#8C8C8C"
              ];
              brights = [
                "#444444" "#FF6D6D" "#89FF95" "#FFF484"
                "#97DDFF" "#FDAAF2" "#85F5DA" "#E9E9E9"
              ];
              background = "#1B1B1B";
              cursor_bg = "#BEAF8A";
              cursor_border = "#BEAF8A";
              cursor_fg = "#1B1B1B";
              foreground = "#BEAF8A";
              selection_bg = "#444444";
              selection_fg = "#E9E9E9";
            };
	  };
	};
	nnn.enable = true;
      };
      vm = {
        lxd.enable = true;
        qemu.enable = true;
	virtualbox.enable = true;
	virt-manager.enable = true;
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
        #ibus.enable = true;
        fcitx5 = {
	  enable = true;
	  #addons = [
          #  pkgs.fcitx5-rime
	  #  pkgs.fcitx5-mozc
	  #  pkgs.fcitx5-chinese-addons
	  #  pkgs.fcitx5-gtk
	  #];
	};
	translate.enable = true;
      };
    };
    science = {
      cytoscape.enable = true;
      bioinfo.enable = true;
      math = {
	tools.enable = true;
	mathematica.enable = true;
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
      r.enable = true;
      zeal.enable = true;
      conda.enable = true;
      mamba.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = rec {
        enable = true;
	doom = {
          enable = false;
	  forgeUrl = "https://github.com";
	  repoUrl = "https://github.com/doomemacs/doomemacs";
	  configRepoUrl = "https://github.com/alienzj/doom.d";
	};
      };
      vim.enable = true;
      vscode.enable = true;
      vscodium.enable = true;
      rstudio.enable = true;
      pycharm.enable = true;
      idea.enable = true;
      android-studio.enable = true;
      gaphor.enable = true;
      textpieces.enable = true;
    };
    shell = {
      adl.enable = true;
      vaultwarden.enable = true;
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      tmux.enable   = true;
      zsh.enable    = true;
      zellij.enable = true;
    };
    services = {
      adb.enable = true; # android
      #calibre.enable = true;
      syncthing.enable = true;
      ssh.enable = true;
      docker.enable = true;
      # Needed occasionally to help the parental units with PC problems
      teamviewer.enable = true;
      rdp.enable = true; # remote desktop
      samba.enable = true; # share folders
      printing.enable = true; # RICOH printer
      lockscreen = {
        enable = true;
      	#inactiveInterval = 10;
      };
      flameshot.enable = true;
      #transmission.enable = true;
      shadowsocks-client = {
        enable = true;
	remotePort = 33708;
	localAddress = "127.0.0.1";
	localPort = 1080;
	remoteAddressFile = "/home/alienzj/projects/configuration/shadowsocks/server";
	passwordFile = "/home/alienzj/projects/configuration/shadowsocks/password";
        encryptionMethod = "chacha20-ietf-poly1305";
      };
      rathole-client = {
        enable = true;
	configFile = "/home/alienzj/projects/configuration/rathole/magic_c.toml";
      };
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

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-fortisslvpn
      networkmanager-iodine
      networkmanager-l2tp
      networkmanager-openconnect
      networkmanager-openvpn
      networkmanager-vpnc
      networkmanager-sstp
    ];
  };

  # firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1993 80 443 2223 3389 8080 8888 8787 8891 8791 8892 8792 8893 8793 8894 8794 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
      { from = 8891; to = 8894; }
      { from = 8791; to = 8794; }
    ];
  };

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
