{ stdenv, fetchFromGitHub, lib, enableSharedLibraries ? true, buildPlatform, hostPlatform, buildEnv, buildPackages }:

let binaryen = buildPackages.callPackage ./binaryen.nix {};
in stdenv.mkDerivation ({
  name = "musl";
  src = lib.cleanSource ./musl;
} // lib.optionalAttrs (!enableSharedLibraries) {
  configureFlags = "--disable-shared --enable-static";
  makeFlags = ["lib/libc.a"];
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
