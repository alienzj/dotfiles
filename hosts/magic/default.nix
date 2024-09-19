{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = true;
      hidpi.enable = true;
      apps = {
        net.enable = true;
        rofi.enable = true;
        zoomus.enable = true;
        libreoffice.enable = true;
        wpsoffice.enable = true;
        thunderbird.enable = true;
        transmission.enable = true;
        filezilla.enable = true;
        scrcpy.enable = true;
        rustdesk.enable = true;
        geph.enable = true;
        rdp.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
        chromium.enable = true;
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
        tdesktop.enable = true;
        slack.enable = true;
        discord.enable = true;
        qqwechat.enable = true;
      };
      input.fcitx5.enable = true;
    };
    science = {
      ds.enable = true;
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
        doom = {
          enable = false;
          forgeUrl = "https://github.com";
          repoUrl = "https://github.com/doomemacs/doomemacs";
          configRepoUrl = "https://github.com/alienzj/doom.d";
        };
      };
      vim.enable = true;
      vscode.enable = true;
      #vscodium.enable = true;
      rstudio.enable = true;
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
      adb.enable = true;
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
      rdp.enable = true; # remote desktop
      samba.enable = false; # share folders
      printing = {
        enable = true; # RICOH printer
        sharing = false;
      };
      lockscreen = {
        enable = true;
        inactiveInterval = 10;
      };
      flameshot = {
        enable = true;
        savePath = "/home/alienzj/pictures/flameshot";
      };
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
        configFile = "/home/alienzj/toolkits/ohconfig/rathole/pacman_magic_c.toml";
      };
      #rathole-client-awsman = {
      #  enable = true;
      #  configFile = "/home/alienzj/toolkits/ohconfig/rathole/awsman_magic_c.toml";
      #};
      earlyoom.enable = true;
    };
    utils = {
      sysinfo.enable = true;
      traceroute.enable = true;
    };
    theme.active = "alucard";
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
  services.pcscd.enable = true; # for gpg-agent
  services.timesyncd.enable = true; # to sync time

  # Run unpatched dynamic binaries on NixOS
  programs.nix-ld.enable = true;

  ## Security
  #security.acme.defaults.email = "alienchuj@gmail.com";
}
