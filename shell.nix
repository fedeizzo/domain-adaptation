{ pkgs ? import <nixpkgs> { } }:

let
  shell = builtins.getEnv "SHELL";
in
(pkgs.buildFHSUserEnv {
  name = "domain-adaptation";
  targetPkgs = pkgs: (with pkgs; [
    pkgs.gcc
    pkgs.glib
    pkgs.python39
    pkgs.python39Packages.pip
    pkgs.python39Packages.setuptools
  ]);
  runScript = shell;
}).env
