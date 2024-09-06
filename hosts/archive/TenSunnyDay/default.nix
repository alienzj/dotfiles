{
  pkgs,
  config,
  lib,
  ...
}: {
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
        net.enable = true;
        rofi.enable = true;
        zoomus.enable = true;
        libreoffice.enable = true;
        wpsoffice.enable = true;
        filezilla.enable = true;
        scrcpy.enable = true;
        thunderbird.enable = true;
        geph.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
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
        spotify.enable = true;
        sayonara.enable = true;
        lx-music.enable = true;
      };
      term = {
        default = "xst";
        st.enable = true;
        wezterm.enable = true;
      };
      noter = {
        zotero.enable = true;
      };
      im = {
        qqwechat.enable = true;
      };
      input.fcitx5.enable = true;
    };
    science = {
      cytoscape.enable = true;
      bioinfo.enable = true;
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
      zeal.enable = true;
      ruby.enable = true;
      web.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = rec {
        enable = false;
        doom = {
          enable = false;
          forgeUrl = "https://github.com";
          repoUrl = "https://github.com/doomemacs/doomemacs";
          configRepoUrl = "https://github.com/alienzj/doom.d";
        };
      };
      vim.enable = true;
      vscode.enable = true;
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
      #calibre.enable = true;
      ssh = {
        enable = true;
      };
      docker.enable = true;
      # Needed occasionally to help the parental units with PC problems
      lockscreen = {
        enable = true;
        inactiveInterval = 10;
      };
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
      earlyoom.enable = true;
      proxmox-ve.enable = true;
    };
    utils = {
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
