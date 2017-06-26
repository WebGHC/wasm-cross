{ stdenv, fetchFromGitHub, lib, enableSharedLibraries ? true, buildPlatform, hostPlatform }:

stdenv.mkDerivation ({
  name = "musl";
  src = fetchFromGitHub {
    owner = "jfbastien";
    repo = "musl";
    rev = "30965616cdc35471639b521a5492d702a91c7a31";
    sha256 = "0iql75473wh5fh73136wb13ncyzl17m9jb3yk090r9crg46zcp16";
  };
  patches = [ ./musl.patch ];
} // lib.optionalAttrs (!enableSharedLibraries) {
  configureFlags = "--disable-shared --enable-static";
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
