{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.rstudio;
    R-with-packages = pkgs.unstable.rWrapper.override {
      packages = with pkgs.unstable.rPackages; [
        tidyverse
        tidymodels
        vegan
        quarto
        shiny
        leaflet
        robservable
        ggtree
        ggtreeExtra
        MicrobiotaProcess
        dada2
        DECIPHER
        ggpubr
        ggplotify
        ggalluvial
        ggstar
        forcats
        tidytree
        readxl
        writexl
      ];
    };

    RStudio-with-packages = pkgs.unstable.rstudioWrapper.override{
      packages = with pkgs.unstable.rPackages; [
        tidyverse
        tidymodels
        vegan
        quarto
        shiny
        ggtree
        ggtreeExtra
        MicrobiotaProcess
        dada2
        DECIPHER
        ggpubr
        ggplotify
        ggalluvial
        ggstar
        forcats
        tidytree
        readxl
        writexl
	flextable
        randomForest	
	tinytex
	ymlthis
	knitr
	rmarkdown
	markdown
      ];
    };
in {
  options.modules.editors.rstudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.unstable.rstudio
      #R-with-packages
      #RStudio-with-packages
    ];
  };
}
