{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.rstudio;

  curatedMetagenomicData_ = pkgs.rPackages.buildRPackage {
    name = "curatedMetagenomicData";
    src = pkgs.fetchFromGitHub {
      owner = "waldronlab";
      repo = "curatedMetagenomicData";
      rev = "a8229bf3eaf8c9992838286e58825a32a0f0316";
      #sha256 = lib.fakeSha256;
      hash = "sha256-krRJ/7bZMhKJ0ptOp01MY7PBj1d38+FCMPGkvgTnkO0=";
    };
    propagatedBuildInputs = [
      pkgs.rPackages.SummarizedExperiment
      pkgs.rPackages.TreeSummarizedExperiment
      pkgs.rPackages.AnnotationHub
      pkgs.rPackages.ExperimentHub
      pkgs.rPackages.S4Vectors
      pkgs.rPackages.dplyr
      pkgs.rPackages.magrittr
      pkgs.rPackages.mia
      pkgs.rPackages.purrr
      pkgs.rPackages.rlang
      pkgs.rPackages.stringr
      pkgs.rPackages.tibble
      pkgs.rPackages.tidyr
      pkgs.rPackages.tidyselect
      pkgs.rPackages.DirichletMultinomial
    ];
    nativeBuildInputs = [
      pkgs.R
      #pkgs.rPackages.rlang
      #pkgs.rPackages.knitr
    ];
    buildInputs = [ pkgs.gsl ];
  };

  RStudio-with-packages = pkgs.rstudioWrapper.override {
    packages = with pkgs.rPackages; [
      tidyverse
      tidymodels

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
      quarto
      mathjaxr
      rdoc
    ];
  };
in {
  options.modules.editors.rstudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      #pkgs.rstudio
      RStudio-with-packages
      pkgs.quarto
      pkgs.pandoc
    ];
  };
}
