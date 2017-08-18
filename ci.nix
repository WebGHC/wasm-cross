{}:

with import ./.;
[
  nixpkgs.llvmPackages_HEAD
  nixpkgs.binaryen
  nixpkgs.haskell.compiler.ghcHEAD

  nixpkgsArm.stdenv.cc
  nixpkgsWasm.stdenv.cc

  nixpkgsArm.fib-example
  nixpkgsWasm.fib-example
]
