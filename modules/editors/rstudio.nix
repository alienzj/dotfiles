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
      pkgs.unstable.rPackages.SummarizedExperiment
      pkgs.unstable.rPackages.TreeSummarizedExperiment
      pkgs.unstable.rPackages.AnnotationHub
      pkgs.unstable.rPackages.ExperimentHub
      pkgs.unstable.rPackages.S4Vectors
      pkgs.unstable.rPackages.dplyr
      pkgs.unstable.rPackages.magrittr
      pkgs.unstable.rPackages.mia
      pkgs.unstable.rPackages.purrr
      pkgs.unstable.rPackages.rlang
      pkgs.unstable.rPackages.stringr
      pkgs.unstable.rPackages.tibble
      pkgs.unstable.rPackages.tidyr
      pkgs.unstable.rPackages.tidyselect
      pkgs.unstable.rPackages.DirichletMultinomial
    ];
    nativeBuildInputs = [
      pkgs.unstable.R
      #pkgs.unstable.rPackages.rlang
      #pkgs.unstable.rPackages.knitr
    ];
    buildInputs = [ pkgs.unstable.gsl ];
  };

  RStudio-with-packages = pkgs.unstable.rstudioWrapper.override{
    packages = with pkgs.unstable.rPackages; [
      tidyverse
      # library(tidyverse) will load the core tidyverse packages:
      ## ggplot2, for data visualisation.
      ## dplyr, for data manipulation.
      ## tidyr, for data tidying.
      ## readr, for data import.
      ## purrr, for functional programming.
      ## tibble, for tibbles, a modern re-imagining of data frames.
      ## stringr, for strings.
      ## forcats, for factors.
      ## lubridate, for date/times.

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
    ];
  };
in {
  options.modules.editors.rstudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      #pkgs.unstable.rstudio
      RStudio-with-packages
    ];
  };
}
