{ stdenv, hostPlatform, callPackage, enableSharedLibraries, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "1a1193a8357dd4f42486d625989813f42f87ed7e";
    sha256 = "1rrv2d5nbqw626ikjn1nrg0hdh0iq5p4kkyh3ig60hyi21bl5c58";
  };
in if hostPlatform.arch == "wasm32"
then callPackage ./musl-wasm32.nix { inherit stdenv src; }
else callPackage ./musl-generic.nix { inherit stdenv src enableSharedLibraries; }
