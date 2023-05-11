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
      devtools
      remotes
      tidyverse
      tidymodels
      vegan
      shiny
      ggtree
      ggtreeExtra
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
      tidytree
      readxl
      writexl
      flextable
      randomForest	
      tinytex
      ymlthis
      knitr
      rmarkdown
      curatedMetagenomicData
      SummarizedExperiment
    ];
  };
in {
  options.modules.editors.rstudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.unstable.rstudio
      #RStudio-with-packages
    ];
  };
}
