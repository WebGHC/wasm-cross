{}:

with import ./.;
let
  fromPkgs = pkgs: {
    inherit (pkgs.stdenv) cc;
    inherit (pkgs) fib-example;
  };
in {
  inherit (nixpkgs) binaryen;
  inherit (nixpkgs.haskell.compiler) ghcHEAD;
  inherit (nixpkgsArm.haskellPackages) hello;

  wasm = fromPkgs nixpkgsWasm;
  arm = fromPkgs nixpkgsArm;
}
