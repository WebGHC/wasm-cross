{}:

with import ./.;
[
  nixpkgs.llvmPackages_HEAD
  nixpkgs.binaryen
  nixpkgs.haskell.compiler.ghcHEAD
] ++ builtins.concatLists (builtins.map (pkgs: [
  pkgs.stdenv.cc
  pkgs.fib-example
]) [nixpkgsWasm nixpkgsArm nixpkgsNative])
