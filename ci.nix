{}:

with import ./.;
[
  nixpkgs.llvmPackages_HEAD

  nixpkgsArm.stdenv.cc
  nixpkgsWasm.stdenv.cc

  nixpkgsArm.fib-example
  nixpkgsWasm.fib-example
]
