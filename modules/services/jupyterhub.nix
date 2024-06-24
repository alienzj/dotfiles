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
  devCfg = config.modules.services;
  cfg = devCfg.jupyterhub;
in {
  options.modules.services.jupyterhub = {
    enable = mkBoolOpt false;
    host = mkOpt types.str "0.0.0.0";
    port = mkOpt types.port 8888;
    adminUser = mkOpt types.str "alienzj";
    allowedUser = mkOption {
      type = with types; listOf types.str;
      default = ["alienzj"];
    };
  };
  ## TODO
  ## FIXME
  ##error: cannot coerce a list to a string
  ##c.Authenticator.allowed_users = '${cfg.allowedUser}'

  config = mkMerge [
    (mkIf cfg.enable {
      services.jupyterhub = {
        enable = true;
        host = cfg.host;
        port = cfg.port;

        authentication = "jupyterhub.auth.PAMAuthenticator";
        spawner = "systemdspawner.SystemdSpawner";
        extraConfig = ''
          c.Authenticator.admin_users = '${cfg.adminUser}'

          ## TODO
          ##c.Authenticator.allow_all = True
          c.Authenticator.allowed_users = ['alienzj']

          c.SystemdSpawner.mem_limit = '80G'
          c.SystemdSpawner.cpu_limit = 10
        '';

        stateDirectory = "jupyterhub";

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

        # python kernel
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
              "${env.interpreter}"
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
            logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
          };
        };

        # R kernel
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
              "${env}/bin/R"
              "--slave"
              "-e"
              "IRkernel::main()"
              "--args"
              "{connection_file}"
            ];
            language = "R";
            #/home/alienzj/R/x86_64-redhat-linux-gnu-library/4.4/IRkernel/kernelspec/
            #  ├── kernel.js
            #  ├── kernel.json
            #  ├── logo-64x64.png
            #  └── logo-svg.svg
            logo64 = "${env}/lib/R/library/IRkernel/kernelspec/logo-64x64.png";
          };
        };
      };
    })
  ];
}
