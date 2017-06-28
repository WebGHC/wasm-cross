{ stdenv, hostPlatform, callPackage, enableSharedLibraries, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "d459240e2da7450eae449f88e0bfdfcc5b2a4546";
    sha256 = "0z8z3wcxfqzasimf4y117vb5izlm9g2b7bcn4gxl2s889rgz79dr";
  };
in if hostPlatform.arch == "wasm32"
then callPackage ./musl-wasm32.nix { inherit stdenv src; }
else callPackage ./musl-generic.nix { inherit stdenv src enableSharedLibraries; }
