{ stdenv, lib, enableSharedLibraries ? true, buildPlatform, hostPlatform, src }:

stdenv.mkDerivation ({
  name = "musl";
  inherit src;
} // lib.optionalAttrs (!enableSharedLibraries) {
  configureFlags = "--disable-shared --enable-static";
  makeFlags = ["lib/libc.a"];
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
