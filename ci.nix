{}:

let wasm-cross = import ./.;
in [
  wasm-cross.nixpkgsCross.stdenv.cc
]
