{}:

with import ./. { overlays = [(import ./haskell-examples)]; };
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
  inherit (nixpkgs.llvmPackages_HEAD) llvm clang clang-unwrapped compiler-rt
    lld bintools; # lldb libcxx libcxx-headers libcxxabi libunwind
  inherit (nixpkgs) binaryen cmake wabt webabi;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm // {
    inherit (nixpkgsWasm.haskell.packages.ghcWasm) hello ghc;
    fib-example-web = nixpkgsWasm.fib-example;
    hello-example-web = nixpkgsWasm.hello-example;
    haskell-example-web = nixpkgsWasm.haskell-example;
    # primitive = nixpkgsWasm.haskell.packages.ghcWasm.primitive;
  });
  # rpi = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsRpi);
  # arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm);

  #examples = nixpkgs.recurseIntoAttrs {
  #  inherit (nixpkgsWasm.examples) wasm;
  #  inherit (nixpkgs.examples) ghcjs;
  #};
}
