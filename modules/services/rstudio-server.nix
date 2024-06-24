# reference
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/development/rstudio-server/default.nix
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.rstudio-server;
  rstudio-server-with-packages = pkgs.unstable.rstudioServerWrapper.override {
    packages = with pkgs.unstable.rPackages; [
      tidyverse
      tidymodels
      infer
      devtools
      remotes
      feather
      httr
      jsonlite
      xml2
      stringi
      curl
      shiny
      knitr
      rmarkdown
      tinytex
      ymlthis
      vegan
      ggtree
      ggtreeExtra
      tidytree
      MicrobiotaProcess
      MicrobiomeProfiler
      clusterProfiler
      enrichplot
      dada2
      DECIPHER
      ggpubr
      ggplotify
      ggalluvial
      ggstar
      ggnewscale
      coin
      forcats
      writexl
      flextable
      randomForest
      curatedMetagenomicData
      SummarizedExperiment
      Rcpp
      Rcpp11
      Maaslin2
      pkgconfig
      ComplexHeatmap
      circlize
      pagedown
      reshape2
      yaml
      optparse
      glue
      V8
      languageserver
    ];
  };
in {
  options.modules.services.rstudio-server = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.rstudio-server = {
      enable = true;
      listenAddr = "0.0.0.0";
      # environment.systemPackages
      ## package = rstudioServerWrapper.override { packages = [ pkgs.rPackages.ggplot2 ]; };
      package = rstudio-server-with-packages;
    };

    networking.firewall.allowedTCPPorts = [8787];
  };
}
