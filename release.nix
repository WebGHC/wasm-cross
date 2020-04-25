{}:

with import ./. { overlays = [(import ./common-overlays.nix) (import ./haskell-examples)]; };
let
  inherit (nixpkgs) lib;
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) musl-cross;
    fib-example = pkgs.fib-example.pkg;
    hello-example = pkgs.hello-example.pkg;
    inherit (pkgs.haskell.packages.integer-simple.ghc881) hello ghc;
  };
in {
  inherit (nixpkgs.llvmPackages_8) llvm clang clang-unwrapped compiler-rt
    lld bintools;
  inherit (nixpkgs) binaryen cmake wabt webabi;
  inherit (nixpkgsWasm) wasmHaskellPackages;
  wasmHaskellPackages865 = nixpkgsWasm865.wasmHaskellPackages;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm // {
    inherit (nixpkgsWasm.haskell.packages.ghcWasm) hello ghc;
    fib-example-web = nixpkgsWasm.fib-example;
    hello-example-web = nixpkgsWasm.hello-example;
    haskell-example-web = nixpkgsWasm.haskell-example;
    primitive = nixpkgsWasm.haskell.packages.ghcWasm.primitive;
  });

  wasm865 = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm865 // {
    inherit (nixpkgsWasm865.haskell.packages.ghcWasm) hello ghc;
    fib-example-web = nixpkgsWasm865.fib-example;
    hello-example-web = nixpkgsWasm865.hello-example;
    haskell-example-web = nixpkgsWasm865.haskell-example;
    primitive = nixpkgsWasm865.haskell.packages.ghcWasm.primitive;
  });

  examples = nixpkgs.recurseIntoAttrs {
    inherit (nixpkgsWasm.examples) wasm;
    wasm865 = nixpkgsWasm865.examples.wasm;
    inherit (nixpkgs.examples) ghcjs;
  };
}
