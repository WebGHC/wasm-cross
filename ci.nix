{}:

let
  ci-project = project: with project;
    [
      nixpkgs.llvmPackages_HEAD
      nixpkgs.binaryen
      nixpkgs.haskell.compiler.ghcHEAD

      nixpkgsArm.haskellPackages.hello
    ] ++ builtins.concatLists (builtins.map (pkgs: [
      pkgs.stdenv.cc
      pkgs.fib-example
    ]) [nixpkgsWasm nixpkgsArm nixpkgsNative]);
in ci-project (import ./. {}) ++ ci-project (import ./. { debugClang = true; })
