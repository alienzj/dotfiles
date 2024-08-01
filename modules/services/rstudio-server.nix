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
      languageserver
      lobstr
      waldo
      ## development
      devtools
      remotes
      pak
      pkgdepends
      pkgbuild
      pkgconfig
      rmarkdown
      pagedown
      knitr
      tinytex
      ## report
      roxygen2
      pkgdown
      ## benchmark
      bench
      testthat
      ## format
      styler
      lintr
      ## system
      callr
      fs
      processx
      ## utils
      here
      yaml
      ymlthis
      usethis
      withr
      cli
      optparse
      sessioninfo
      progress

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
      magrittr
      purrr
      ## read and write
      xopen
      readr
      readxl
      writexl
      vroom
      haven
      feather
      nanoparquet
      jsonlite
      ## data frame
      tibble
      dplyr
      reshape2
      dtplyr
      dbplyr
      multidplyr
      tidyr
      glue
      ## string
      stringr
      stringi
      reprex
      ## factors
      forcats
      ## dates
      lubridate
      hms
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
      ggplot2
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
      #microshades

      # tidy modeling and test
      ## preprocess
      modeldata
      modeldatatoo
      recipes
      rsample
      applicable
      themis
      ## interface
      parsnip
      bonsai
      censored
      multilevelmod
      tidyclust
      discrim
      rules
      ## functions
      brulee
      ## test
      dunn_test
      ## linear models
      geepack
      ## classification and regression
      randomForest
      poissonreg
      ## prediction
      tidypredict
      ## running
      modeldb
      ## statistical inference
      infer
      ## correlation
      corrr
      ## tuning
      tune
      finetune
      dials
      ## performance
      yardstick
      ## others
      cutpointr
      coin
      ## workflow
      orbital
      stacks
      butcher
      workflows
      workflowsets
      ## summary
      insight
      probably
      broom

      # bioinformatics
      ## general
      SummarizedExperiment
      clusterProfiler
      enrichplot
      ## microbiome
      vegan
      curatedMetagenomicData
      MicrobiotaProcess
      MicrobiomeProfiler
      Maaslin2
      dada2
      DECIPHER
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
