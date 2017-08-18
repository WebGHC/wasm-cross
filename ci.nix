{}:

with import ./.;
[
  nixpkgs.llvmPackages_HEAD
  nixpkgs.binaryen

  nixpkgsArm.stdenv.cc
  nixpkgsWasm.stdenv.cc

  nixpkgsArm.fib-example
  nixpkgsWasm.fib-example
]
