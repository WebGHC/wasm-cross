{}:

with import ./.;
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) fib-example;
  };
in {
  inherit (nixpkgs.llvmPackages_HEAD) llvm clang compiler-rt libcxx
    libcxx-headers libcxxabi libunwind lld lldb llvm-binutils;
  inherit (nixpkgs) binaryen;
  inherit (nixpkgs.haskell.compiler) ghcHEAD;
  inherit (nixpkgsArm.haskellPackages) hello;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm);
  arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm);
}
