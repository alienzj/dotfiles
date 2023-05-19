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
      openai
      openaiauth
    ]; 
    python-with-my-packages = pkgs.python311.withPackages my-python-packages;

in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        #python-with-my-packages

        python311
        python311Packages.pip
        python311Packages.black
        python311Packages.setuptools
        python311Packages.pylint
        python311Packages.poetry-core
        python311Packages.ipython
        #python311Packages.flask
        #python311Packages.django
      	#python311Packages.dash
        #python311Packages.plotly
        #python311Packages.requests
        #python311Packages.jupyter
        #python311Packages.jupyterlab
        #python311Packages.pandas
        #python311Packages.numpy
        #python311Packages.matplotlib
        #python311Packages.seaborn
        #python311Packages.scipy
        #python311Packages.openai
        #python311Pacakges.openaiauth
	#python311Packages.tiktoken
	#python311Packages.openai-whisper
	#python311Packages.torch
	#python311Packages.tensorflow
	#python311Packages.keras
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
