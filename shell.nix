{ pkgs ? import <nixpkgs> { } }:

let
  mach-nix = import
    (builtins.fetchGit {
      url = "https://github.com/DavHau/mach-nix/";
      # ref = "refs/tags/3.3.0";
      ref = "master";
    })
    {
      python = "python39";
      # "https://github.com/DavHau/pypi-deps-db"
      pypiDataRev = "43f5b07a0b1614ee80723b2ad2f8e29a7b246353";
      pypiDataSha256 = "sha256:0psv5w679bgc90ga13m3pz518sw4f35by61gv7c64yl409p70rf9";
    };
  python-mach = mach-nix.mkPython {
    requirements = builtins.readFile ./requirements.txt;
    providers = {
      _defualt = "sdist";
    };
  };
  pythonDeps = pkgs.python39.withPackages
    (ps: [
      ps.ipython
      ps.matplotlib-inline
      ps.jupyter
      ps.jupyter_console
      ps.jupyter-client
      ps.pytorch-bin
      ps.torchvision-bin
    ]);
  buildInputs = [
    pkgs.python39
    pythonDeps
    python-mach
  ];
  # LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc]}";
  # shellHook = ''
  #   export LD_PRELOAD="/run/opengl-driver/lib/libcuda.so"
  # '';
  # pkgs.mkShell {
  # }
  shell = builtins.getEnv "SHELL";
in
(pkgs.buildFHSUserEnv {
  name = "domain-adaptation";
  targetPkgs = pkgs: (with pkgs; [
    pkgs.python39
    pkgs.python39Packages.pip
    pkgs.python39Packages.setuptools
  ]);
  runScript = shell;
}).env
