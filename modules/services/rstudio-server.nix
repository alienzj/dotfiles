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
      # infrastructure
      ## lang
      rlang
      repr
      IRkernel
      IRdisplay

      ## development
      devtools
      remotes
      rmarkdown
      knitr

      ## benchmark
      bench

      ## format
      styler
      lintr

      # data structure and functions
      ## maps
      fastmap

      ## functions
      slider

      ## regrex
      rex

      ## cpp
      cpp11

      # tidy data manipulation
      ## core
      tidyverse

      ## read and write
      xopen
      haven
      feather
      nanoparquet
      jsonlite

      ## web data
      rvest
      httr
      httr2
      xml2
      curl
      V8

      # tidy data visualization
      ## interactive
      shiny

      ## general
      scales
      svglite
      ggpubr
      ggplotify
      ggalluvial
      ggstar
      ggnewscale
      ggdensity
      ggside
      ggsankeyfier
      ggblend
      ggh4x
      gghalves
      ggsignif

      ## tree
      tidytree
      ggtree
      ggtreeExtra

      ## heatmap
      ComplexHeatmap
      circlize

      ## correlation
      cowplot

      ## table summary
      gtsummary
      flextable
      gt
      gtExtras

      ## color
      #tidy modeling and test
      tidymodels

      # bioinformatics
      ## general
      SummarizedExperiment
      clusterProfiler
      enrichplot

      ## microbiome
      vegan
      DirichletMultinomial
      curatedMetagenomicData
      MicrobiotaProcess
      MicrobiomeProfiler
      Maaslin2
      SIAMCAT
      phyloseq
      dada2
      decontam
      DECIPHER
      fido
      # remotes::install_github("mikemc/speedyseq")
      # remotes::install_github("KarstensLab/microshades", dependencies = TRUE)
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
