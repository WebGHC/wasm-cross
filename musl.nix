{ stdenv, lib, buildPackages, fetchFromGitHub, hostPlatform, buildPlatform }:

stdenv.mkDerivation ({
  name = "musl";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "03011add468f294f95cf0a03d2d7f1a45fe52e55";
    sha256 = "0i3cdlspqbwpdbs13k7flhyz53r05zq2kr6w97qacq4ik1s7n9ww";
  };

  postInstall = ''
    for f in crtbegin crtend crtbeginS crtendS; do
      touch $f.c
      $CC -c -o $out/lib/$f.o $f.c
    done
  '';

  enableParallelBuilding = true;
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
