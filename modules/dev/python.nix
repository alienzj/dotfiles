# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;

let devCfg = config.modules.dev;
    cfg = devCfg.python;

    my-python-packages = p: with p; [
      pip
      black
      setuptools
      pylint
      poetry
      flask
      django
      dash
      plotly
      requests
      ipython
      jupyter
      jupyterlab
      pandas
      numpy
      matplotlib
      seaborn
      scipy
    ]; 
    python-with-my-packages = pkgs.python3.withPackages my-python-packages;

in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        #python-with-my-packages
        python39
        python39Packages.pip
        python39Packages.black
        python39Packages.setuptools
        python39Packages.pylint
        #python39Packages.poetry
        python39Packages.ipython
      ];

      environment.shellAliases = {
        py     = "python";
        py2    = "python2";
        py3    = "python3";
        po     = "poetry";
        ipy    = "ipython --no-banner";
        ipylab = "ipython --pylab=qt5 --no-banner";
      };
    })

    (mkIf cfg.xdg.enable {
      env.IPYTHONDIR      = "$XDG_CONFIG_HOME/ipython";
      env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      env.PIP_LOG_FILE    = "$XDG_DATA_HOME/pip/log";
      env.PYLINTHOME      = "$XDG_DATA_HOME/pylint";
      env.PYLINTRC        = "$XDG_CONFIG_HOME/pylint/pylintrc";
      env.PYTHONSTARTUP   = "$XDG_CONFIG_HOME/python/pythonrc";
      env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
      env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    })
  ];
}
