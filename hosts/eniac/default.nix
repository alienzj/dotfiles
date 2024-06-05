{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  disabledModules = [ "services/networking/jotta-cli.nix" ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = true;
      hidpi.enable = true;
      apps = {
        rofi.enable = true;
        zoomus.enable = true;
        libreoffice.enable = true;
        wpsoffice.enable = true;
        godot.enable = true;
        transmission.enable = true;
        filezilla.enable = true;
        scrcpy.enable = true;
        anydesk.enable = true;
        rustdesk.enable = true;
        authenticator.enable = true;
        geph.enable = true;
        synology-drive-client.enable = true;
        vpn.enable = true;
        file-manager.enable = true;
        rdp.enable = true;
        goldendict.enable = true;
      };
      browsers = {
        default = "brave";
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
        netease-cloud-music.enable = true;
        lx-music.enable = true;
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
        virt-manager.enable = true;
      };
      noter = {
        zotero.enable = true;
      };
      im = {
        matrix.enable = true;
        tdesktop.enable = true;
        whatsapp.enable = true;
        slack.enable = true;
        discord.enable = true;
        zulip.enable = true;
        qqwechat.enable = true;
      };
      input = {
        fcitx5 = {
          enable = true;
        };
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
        wolframengine.enable = false;
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
      r.enable = true;
      julia.enable = true;
      go.enable = true;
      haskell.enable = true;
      zeal.enable = true;
      conda.enable = true;
      mamba.enable = true;
      ruby.enable = true;
      web.enable = true;
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
      vscode_fhs.enable = true;
      vscodium.enable = true;
      rstudio.enable = true;
      rstudio-server.enable = false;
      idea.enable = true;
      android-studio.enable = true;
    };
    shell = {
      adl.enable = true;
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      fish.enable = true;
    };
    services = {
      adb.enable = true; # android
      syncthing.enable = true;
      ssh = {
        enable = true;
      };
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
      rathole-client-awsman = {
        enable = true;
        configFile = "/home/alienzj/toolkits/ohconfig/rathole/awsman_eniac_c.toml";
      };
      boinc.enable = false;
      slurm.enable = false;
      earlyoom.enable = true;
      home-assistant.enable = true;
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
  services.pcscd.enable = true; # for gpg-agent
  services.timesyncd.enable = true; # to sync time
}