{}:

with import ./. {};
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) musl-cross;
    fib-example = pkgs.fib-example.drv;
    hello-example = pkgs.hello-example.drv;
    inherit (pkgs.haskell.packages.ghcHEAD) hello ghc;
  };
in {
  inherit (nixpkgs.llvmPackages_HEAD) llvm clang clang-unwrapped compiler-rt
    lld lldb llvm-binutils; # libcxx libcxx-headers libcxxabi libunwind
  inherit (nixpkgs) binaryen cmake wabt webabi;
  inherit (nixpkgs.haskell.packages.ghcHEAD) ghc;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm // {
    fib-example-web = nixpkgsWasm.fib-example;
    hello-example-web = nixpkgsWasm.hello-example;
    haskell-example-web = nixpkgsWasm.haskell-example;
    primitive = nixpkgsWasm.haskell.packages.ghcHEAD.primitive;
  });
  # rpi = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsRpi);
  arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm);
}
