# modules/browser/brave.nix --- https://publishers.basicattentiontoken.org
#
# A FOSS and privacy-minded browser.
{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.browsers.brave;
in {
  options.modules.desktop.browsers.brave = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      brave
      (mkLauncherEntry "Brave Web Browser (Private)" {
        description = "Open a private Brave window";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito";
        categories = ["Network"];
      })
      (mkLauncherEntry "Brave Web Browser (Proxy pacman)" {
        description = "Open a Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = ["Network"];
      })
      (mkLauncherEntry "Brave Web Browser (Proxy geph)" {
        description = "Open a Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:9909\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:9909\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:9909\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --proxy-server=\"socks5://127.0.0.1:9909\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = ["Network"];
      })
      (mkLauncherEntry "Brave Web Browser (Private Proxy pacman)" {
        description = "Open a private Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:1080\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = ["Network"];
      })
      (mkLauncherEntry "Brave Web Browser (Private Proxy geph)" {
        description = "Open a private Brave window with proxy";
        icon = "brave";
        exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:9909\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:9909\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:9909\" --proxy-pac-url=\"file://home/alienzj/.config/gfw2pac/gfwlist_2.pac\"";
        #exec = "${brave}/bin/brave --incognito --proxy-server=\"socks5://127.0.0.1:9909\" --proxy-pac-url=\"https://raw.sevencdn.com/petronny/gfwlist2pac/master/gfwlist.pac\"";
        categories = ["Network"];
      })
    ];

    home.configFile = {
      "gfw2pac/gfwlist.pac".source = "${hey.configDir}/gfw2pac/gfwlist.pac";
      "gfw2pac/gfwlist_2.pac".source = "${hey.configDir}/gfw2pac/gfwlist_2.pac";
    };
  };
}
