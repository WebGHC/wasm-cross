{}:

with import ./. {};
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) fib-example hello-example musl-cross;
    inherit (pkgs.haskell.packages.ghcHEAD) hello ghc;
  };
in {
  inherit (nixpkgs.llvmPackages_HEAD) llvm clang clang-unwrapped compiler-rt
    lld lldb llvm-binutils; # libcxx libcxx-headers libcxxabi libunwind
  inherit (nixpkgs) binaryen cmake wabt webabi;
  inherit (nixpkgs.haskell.packages.ghcHEAD) ghc;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm);
  # rpi = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsRpi);
  arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm);
}
