# reference
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/development/jupyterhub/default.nix
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.jupyterhub;
in {
  options.modules.dev.jupyterhub = {
    enable = mkBoolOpt false;
    host = mkOpt types.str "0.0.0.0";
    port = mkOpt types.port 8888;
    xdg.enable = mkBoolOpt devCfg.enableXDG;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.jupyterhub = {
        enable = true;
        host = cfg.host;
        port = cfg.port;

        # Python environment to run jupyterhub
        jupyterhubEnv = pkgs.python3.withPackages (p:
          with p; [
            jupyterhub
            jupyterhub-systemdspawner
          ]);

        # Python environment to run jupyterlab
        jupyterlabEnv = pkgs.python3.withPackages (p:
          with p; [
            jupyterhub
            jupyterlab
          ]);
      };

      ## services.jupyterhub.kernels.<name>.logo64
      ## services.jupyterhub.kernels.<name>.logo32
      ## services.jupyterhub.kernels.<name>.language
      ## services.jupyterhub.kernels.<name>.extraPaths
      ## services.jupyterhub.kernels.<name>.env
      ## services.jupyterhub.kernels.<name>.displayName
      ## services.jupyterhub.kernels.<name>.argv
      kernels = {
        biopy = let
          env = pkgs.python3.withPackages (pythonPackages:
            with pythonPackages; [
              ipykernel
              pandas
              numpy
              matplotlib
              seaborn
              scikit-learn
              lightgbm
              xgboost
              statsmodels
              torch
              torchvision
              torchaudio
              torchsummary
            ]);
        in {
          displayName = "Python 3 for data science";
          argv = [
            "''${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
          logo32 = "''${env}/''${env.sitePackages}/ipykernel/resources/logo-32x32.png";
          logo64 = "''${env}/''${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        };
      };

      ## https://github.com/IRkernel/IRkernel
      kernels = {
        bioR = let
          env = pkgs.unstable.rWrapper.override {
            packages = with pkgs.unstable.rPackages; [
              repr
              IRkernel
              IRdisplay
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
          displayName = "R for data science";
          ## https://github.com/IRkernel/IRkernel/blob/master/inst/kernelspec/kernel.json
          ### {"argv":
          ###  ["R", "--slave", "-e", "IRkernel::main()", "--args", "{connection_file}"],
          ###   "display_name":"R",
          ###   "language":"R"
          ### }
          argv = [
            "''${env.interpreter}"
            "--slave"
            "-e"
            "IRkernel::main()"
            "--args"
            "{connection_file}"
          ];
          language = "R";
          logo64 = "''${env}/''${env.sitePackages}/irkernel/resources/logo-64x64.png";
        };
      };
    })
  ];
}
