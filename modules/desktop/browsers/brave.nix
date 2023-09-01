# modules/browser/brave.nix --- https://publishers.basicattentiontoken.org
#
# A FOSS and privacy-minded browser.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.brave;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.brave = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      brave
      (makeDesktopItem {
        name = "brave-private";
        desktopName = "Brave Web Browser (Private)";
        genericName = "Open a private Brave window";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito";
        categories = [ "Network" ];
      })
      (makeDesktopItem {
        name = "brave-proxy-pacman";
        desktopName = "Brave Web Browser (Proxy pacman)";
        genericName = "Open a Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = [ "Network" ];
      })
      (makeDesktopItem {
        name = "brave-proxy-superman";
        desktopName = "Brave Web Browser (Proxy superman)";
        genericName = "Open a Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1081\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1081\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1081\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1081\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = [ "Network" ];
      })
      (makeDesktopItem {
        name = "brave-proxy-awsman";
        desktopName = "Brave Web Browser (Proxy awsman)";
        genericName = "Open a Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1082\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1082\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1082\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1082\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = [ "Network" ];
      })
      (makeDesktopItem {
        name = "brave-private-proxy-pacman";
        desktopName = "Brave Web Browser (Private Proxy pacman)";
        genericName = "Open a private Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = [ "Network" ];
      })
      (makeDesktopItem {
        name = "brave-private-proxy-superman";
        desktopName = "Brave Web Browser (Private Proxy superman)";
        genericName = "Open a private Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1081\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1081\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1081\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1081\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = [ "Network" ];
      })
      (makeDesktopItem {
        name = "brave-private-proxy-awsman";
        desktopName = "Brave Web Browser (Private Proxy awsman)";
        genericName = "Open a private Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1082\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1082\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1082\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1082\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = [ "Network" ];
      })
    ];

    home.configFile = {
      "gfw2pac/gfwlist.pac".source = "${configDir}/gfw2pac/gfwlist.pac";
      "gfw2pac/gfwlist_2.pac".source = "${configDir}/gfw2pac/gfwlist_2.pac";
    };
  };
}
