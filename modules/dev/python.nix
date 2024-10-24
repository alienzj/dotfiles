# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.
## reference
## https://wiki.nixos.org/wiki/Python
{
  config,
  options,
  lib,
  pkgs,
  my,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.python;

  # method 1
  python-with-packages = pkgs.unstable.python311.withPackages (python-pkgs:
    with python-pkgs; [
      python
      pip

      conda
      conda-libmamba-solver
      #$ conda create -n bioenv3.12 python=3.12
      #CondaError: Conda has not been initialized.
      #To enable full conda functionality, please run 'conda init'.
      #For additional information, see 'conda init --help'.
      #$conda init
      #Cannot install xonsh wrapper without a python interpreter in prefix: /home/alienzj/.conda
      #Cannot install xonsh wrapper without a python interpreter in prefix: /home/alienzj/.conda
      #$error again
      #very strange

      virtualenv

      black
      setuptools
      pylint

      # how to install poetry
      poetry-core

      grip
      pyflakes
      isort
      pytest
      cython

      # mkdocs
      mkdocs
      mkdocs-material
      mdformat-mkdocs
      neoteroi-mkdocs

      # repl
      ipython
      ipykernel

      # data science
      pandas
      polars
      xlsxwriter
      openpyxl
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
      ## dmlc
      xgboost
      ## Microsoft
      lightgbm
      ## Meta
      torch
      torchvision
      torchaudio
      torchsummary
      ## Google
      jax
      #keras # depend on tensorflow
      # https://github.com/NixOS/nixpkgs/issues/329378
      #tensorflow
      tensorflow-bin
      #tensorboard
    ]);

  python = pkgs.unstable.python311;
  #python = python-with-packages;

  # We currently take all libraries from systemd and nix as the default
  # https://github.com/NixOS/nixpkgs/blob/c339c066b893e5683830ba870b1ccd3bbea88ece/nixos/modules/programs/nix-ld.nix#L44
  pythonldlibpath = lib.makeLibraryPath (with pkgs.unstable; [
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd
  ]);

  # method 2 (nix-ld)
  patchedpython_nix_ld = python.overrideAttrs (
    previousAttrs: {
      # Add the nix-ld libraries to the LD_LIBRARY_PATH.
      # creating a new library path from all desired libraries

      #FAILED tests/unit/discovery/py_info/test_py_info.py::test_fallback_existent_system_executable
      #AssertionError: assert 'unpatched_python3.11' in ['python3', 'python3.11']

      postInstall =
        previousAttrs.postInstall
        + ''
          mv  "$out/bin/python3.11" "$out/bin/unpatched_python3.11"
          cat << EOF >> "$out/bin/python3.11"
          #!/run/current-system/sw/bin/bash
          export LD_LIBRARY_PATH="${pythonldlibpath}"
          exec "$out/bin/unpatched_python3.11" "\$@"
          EOF
          chmod +x "$out/bin/python3.11"
        '';
    }
  );
  ## if you want poetry
  patchedpoetry_nix_ld = (pkgs.unstable.poetry.override {python3 = patchedpython_nix_ld;}).overrideAttrs (
    previousAttrs: {
      # same as above, but for poetry
      # not that if you dont keep the blank line bellow, it crashes :(
      postInstall =
        previousAttrs.postInstall
        + ''

          mv "$out/bin/poetry" "$out/bin/unpatched_poetry"
          cat << EOF >> "$out/bin/poetry"
          #!/run/current-system/sw/bin/bash
          export LD_LIBRARY_PATH="${pythonldlibpath}"
          exec "$out/bin/unpatched_poetry" "\$@"
          EOF
          chmod +x "$out/bin/poetry"
        '';
    }
  );

  # method 3 (wrapProgram)
  ## Darwin requires a different library path prefix
  wrapPrefix =
    if (!pkgs.stdenv.isDarwin)
    then "LD_LIBRARY_PATH"
    else "DYLD_LIBRARY_PATH";
  patchedpython_wrapper = pkgs.symlinkJoin {
    name = "python";
    #paths = [python];
    paths = [python-with-packages];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/python3.11" --prefix ${wrapPrefix} : "${pythonldlibpath}"
    '';
  };
  patchedpoetry_wrapper = pkgs.symlinkJoin {
    name = "poetry";

    #paths = [pkgs.unstable.poetry];
    #undefined variable 'python311'
    #paths = [(pkgs.unstable.poetry.override {python3 = python311;})];
    paths = [(pkgs.unstable.poetry.override {python3 = python;})];

    # why not works
    #paths = [(pkgs.unstable.poetry.override {python3 = python-with-packages;})];

    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/poetry" --prefix ${wrapPrefix} : "${pythonldlibpath}"
    '';
  };
in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
    nix-ld.enable = mkBoolOpt false;
    wrapProgram.enable = mkBoolOpt false;
  };

  config = mkMerge [
    # method 1
    (mkIf (cfg.enable && (!cfg.nix-ld.enable) && (!cfg.wrapProgram.enable)) {
      user.packages = [
        python-with-packages
      ];
      # method 0
      #user.packages =
      #  (with pkgs.unstable; [
      #    python311
      #    pipenv
      #    (poetry.override {python3 = python311;})
      #  ])
      #  ++ (
      #    with pkgs.unstable.python311Packages; [
      #      pip
      #      black
      #      setuptools
      #      pylint
      #      poetry-core
      #      grip
      #      pyflakes
      #      isort
      #      pytest
      #      cython

      #      # core
      #      ipython
      #      ipykernel

      #      # data science
      #      pandas
      #      polars
      #      xlsxwriter
      #      numpy
      #      scipy
      #      scikit-learn
      #      statsmodels

      #      # plot
      #      matplotlib
      #      seaborn
      #      plotnine

      #      # bioinformatics
      #      biopython
      #      scikit-bio

      #      # AI
      #      ## dmlc
      #      xgboost
      #      ## Microsoft
      #      lightgbm
      #      ## Meta
      #      torch
      #      torchvision
      #      torchaudio
      #      torchsummary
      #      ## Google
      #      jax
      #      #keras # depend on tensorflow
      #      # https://github.com/NixOS/nixpkgs/issues/329378
      #      #tensorflow
      #      tensorflow-bin
      #      #tensorboard
      #    ]
      #  );
    })

    # method 2
    (mkIf (cfg.enable && (cfg.nix-ld.enable) && (!cfg.wrapProgram.enable)) {
      user.packages = with pkgs.unstable; [
        patchedpython_nix_ld
        patchedpoetry_nix_ld
      ];
    })

    # method 3
    (mkIf (cfg.enable && (!cfg.nix-ld.enable) && (cfg.wrapProgram.enable)) {
      user.packages = with pkgs.unstable; [
        patchedpython_wrapper
        patchedpoetry_wrapper
      ];
    })

    (mkIf cfg.enable {
      environment.shellAliases = {
        py = "python";
        py2 = "python2";
        py3 = "python3";
        po = "poetry";
        ipy = "ipython --no-banner";
        ipylab = "ipython --pylab=qt5 --no-banner";
      };
    })

    (mkIf cfg.xdg.enable {
      env.IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
      env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      env.PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
      env.PYLINTHOME = "$XDG_DATA_HOME/pylint";
      env.PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
      env.PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
      env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    })
  ];
}
