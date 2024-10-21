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
      networking.firewall.allowedTCPPorts = [cfg.port];

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
        jupyterhubEnv = pkgs.unstable.python311.withPackages (p:
          with p; [
            jupyterhub
            jupyterhub-systemdspawner
          ]);

        # Python environment to run jupyterlab
        jupyterlabEnv = pkgs.unstable.python311.withPackages (p:
          with p; [
            jupyterhub
            jupyterlab
          ]);

        # python kernel
        kernels = {
          biopy = let
            env = pkgs.unstable.python311.withPackages (pythonPackages:
              with pythonPackages; [
                # core
                ipykernel

                # data science
                pandas
                polars
                xlsxwriter
                numpy
                scipy
                scikit-learn
                statsmodels

                # plot
                matplotlib
                seaborn
                plotnine

                # bioinformatics
                biopython
                scikit-bio

                # AI
                lightgbm
                xgboost
                jax
                keras
                tensorflow
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

            ### /nix/store/fmfkx19rgwqnf8f9nqmcdacig2vig1x9-r-IRkernel-1.3.2/library/IRkernel/kernelspec
            ### ├── kernel.js
            ### ├── kernel.json
            ### ├── logo-64x64.png
            ### └── logo-svg.svg
            ### TODO
            ### FIXME
            #logo64 = "${pkgs.unstable.rPackages.IRkernel}/IRkernel/kernelspec/logo-64x64.png";
          };
        };
      };
    })
  ];
}
