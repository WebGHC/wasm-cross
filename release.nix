{}:

with import ./. {};
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) fib-example hello-example musl-cross;
  };
in {
  inherit (nixpkgs.llvmPackages_HEAD) llvm clang clang-unwrapped compiler-rt
    lld lldb llvm-binutils; # libcxx libcxx-headers libcxxabi libunwind
  inherit (nixpkgs) binaryen;
  inherit (nixpkgs.haskell.compiler) ghcHEAD;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm);
  rpi = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsRpi);
  arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm) // {
    inherit (nixpkgsArm.haskellPackages) hello ghc;
  };
}
