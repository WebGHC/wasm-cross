{ stdenv, hostPlatform, callPackage, enableSharedLibraries }:

if hostPlatform.arch or null == "wasm32"
then callPackage ./musl-wasm32.nix { inherit stdenv; }
else callPackage ./musl-generic.nix { inherit stdenv enableSharedLibraries; }
