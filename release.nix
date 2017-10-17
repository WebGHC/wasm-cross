{}:

with import ./.;
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) fib-example;
  };
in {
  llvmPackages = nixpkgs.recurseIntoAttrs nixpkgs.llvmPackages_HEAD;
  inherit (nixpkgs) binaryen;
  inherit (nixpkgs.haskell.compiler) ghcHEAD;
  inherit (nixpkgsArm.haskellPackages) hello;

  wasm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsWasm);
  arm = nixpkgs.recurseIntoAttrs (fromPkgs nixpkgsArm);
}
