{}:

let wasm-cross = import ./.;
in [
  wasm-cross.nixpkgsArm.stdenv.cc
  wasm-cross.nixpkgsWasm.stdenv.cc
]
