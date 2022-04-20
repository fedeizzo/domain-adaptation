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
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    python39
    python39Packages.ipython
    python39Packages.matplotlib-inline
    python39Packages.jupyter
    python39Packages.jupyter_console
    python39Packages.jupyter-client
  ] ++ [ python-mach ];
}
