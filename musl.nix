{ stdenv, lib, buildPackages, fetchFromGitHub, hostPlatform, buildPlatform }:

stdenv.mkDerivation ({
  name = "musl";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "122fb45ac55ee634e734d82df141715f3c5fc6b1";
    sha256 = "1w2vw2y0niafbw7zrbw17s5i8kp9h52fch7qfzy6zz4jggzd2c1s";
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
