{ stdenv, lib, enableSharedLibraries ? true, buildPlatform, hostPlatform, fetchgit }:

stdenv.mkDerivation ({
  name = "musl";
  src = fetchgit {
    url = "git://git.musl-libc.org/musl";
    rev = "a08910fc2cc739f631b75b2d09b8d72a0d64d285";
    sha256 = "1dz743sq9qb7y27xab2s81xla95w9whvahg22m152phjbkwcg9n1";
  };
} // lib.optionalAttrs (!enableSharedLibraries) {
  configureFlags = "--disable-shared --enable-static";
  makeFlags = ["lib/libc.a"];
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
