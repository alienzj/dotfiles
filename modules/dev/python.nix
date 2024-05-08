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
      poetry-core
      flask
      django
      #dash
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
      openai
      openaiauth
    ]; 
    python-with-my-packages = pkgs.python310.withPackages my-python-packages;

in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        #python-with-my-packages

        python310
	pipenv
        python310Packages.pip
        python310Packages.cython
        python310Packages.isort
        python310Packages.pyflakes
        python310Packages.pytest
        python310Packages.nose
        python310Packages.black
        python310Packages.setuptools
        python310Packages.pylint
        python310Packages.poetry-core
        python310Packages.ipython
        python310Packages.grip
        python310Packages.flask
        python310Packages.django
      	#python310Packages.dash
        python310Packages.plotly
        python310Packages.requests
        python310Packages.jupyter
        python310Packages.jupyterlab
        python310Packages.pandas
        python310Packages.numpy
        python310Packages.matplotlib
        python310Packages.seaborn
        python310Packages.scipy
        python310Packages.mkdocs
        python310Packages.mkdocs-material
        python310Packages.mkdocs-jupyter

        #python310Packages.openai
        #python310Pacakges.openaiauth
	#python310Packages.tiktoken
	#python310Packages.openai-whisper
	#python310Packages.torch
	#python310Packages.tensorflow
	#python310Packages.keras
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
