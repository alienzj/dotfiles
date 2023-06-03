{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.chromium;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.chromium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ungoogled-chromium
      #(makeDesktopItem {
      #  name = "chromium-private";
      #  desktopName = "Chromium Web Browser (Private)";
      #  genericName = "Open a private Chromium window";
      #  icon = "chromium";
      #  exec = "${brave}/bin/chromium --incognito";
      #  categories = [ "Network" ];
      #})
      #(makeDesktopItem {
      #  name = "chromium-proxy";
      #  desktopName = "Chromium Web Browser (Proxy)";
      #  genericName = "Open a Chromium window with proxy";
      #  icon = "chromium";
      #  exec = "${brave}/bin/chromium --proxy-server=\"socks5://127.0.0.1:1080\"";
      #  categories = [ "Network" ];
      #})
      #(makeDesktopItem {
      #  name = "chromium-private-proxy";
      #  desktopName = "Chromium Web Browser (Private Proxy)";
      #  genericName = "Open a private Chromium window with proxy";
      #  icon = "brave";
      #  exec = "${brave}/bin/chromium --incognito --proxy-server=\"socks5://127.0.0.1:1080\"";
      #  categories = [ "Network" ];
      #})
    ];

    #home.configFile = {
    #  "gfw2pac/gfwlist.pac".source = "${configDir}/gfw2pac/gfwlist.pac";
    #  "gfw2pac/gfwlist_2.pac".source = "${configDir}/gfw2pac/gfwlist_2.pac";
    #};
  };
}
