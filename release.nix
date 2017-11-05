{}:

with import ./.;
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) fib-example musl-cross;
  };
in {
  inherit (nixpkgs.llvmPackages_HEAD) llvm clang clang-unwrapped compiler-rt
    libcxx libcxx-headers libcxxabi libunwind lld lldb llvm-binutils;
  inherit (nixpkgs) binaryen;
  inherit (nixpkgs.haskell.compiler) ghcHEAD;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm);
  arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm) // {
    inherit (nixpkgsArm.haskellPackages) hello ghc;
  };
}
