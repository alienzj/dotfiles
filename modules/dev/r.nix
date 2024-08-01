{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.r;
  r-with-packages = pkgs.unstable.rWrapper.override {
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
      ggdensity
      ggside
      #gsankey
      ggblend
      ggh4x
      gghalves
      #dunn.test
      cowplot
      gtsummary
      geepack

      #microshades
      coin
      forcats
      writexl
      flextable
      gt
      gtExtras
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
      rlang
      insight
      cutpointr
      svglite
    ];
  };
in {
  options.modules.dev.r = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      r-with-packages
    ];
  };
}
