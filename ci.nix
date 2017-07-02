{}:

with import ./.;
[
  nixpkgsArm.stdenv.cc
  nixpkgsWasm.stdenv.cc

  nixpkgsArm.fib-example
  nixpkgsWasm.fib-example
]
