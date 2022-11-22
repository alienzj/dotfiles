{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.rstudio;
    #zj-R-with-packages = rWrapper.override {
    #  packages = with rPackages; [
    #    tidyverse
    #    tidymodels
    #    vegan
    #    quarto
    #    shiny
    #    leaflet
    #    robservable
    #    ggtree
    #    ggtreeExtra
    #    MicrobiotaProcess
    #    dada2
    #    DECIPHER
    #    ggpubr
    #    ggplotify
    #    ggalluvial
    #    ggstar
    #    forcats
    #    tidytree
    #    readxl
    #    writexl
    #  ];
    #};

    #zj-RStudio-with-packages = rstudioWrapper.override{
    #  packages = with rPackages; [
    #    tidyverse
    #    tidymodels
    #    vegan
    #    quarto
    #    shiny
    #    leaflet
    #    robservable
    #    ggtree
    #    ggtreeExtra
    #    MicrobiotaProcess
    #    dada2
    #    DECIPHER
    #    ggpubr
    #    ggplotify
    #    ggalluvial
    #    ggstar
    #    forcats
    #    tidytree
    #    readxl
    #    writexl
    #  ];
    #};
in {
  options.modules.editors.rstudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.rstudio
      #zj-R-with-packages
      #zj-RStudio-with-packages
    ];
  };
}
