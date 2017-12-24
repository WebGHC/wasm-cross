{ stdenv, lib, buildPackages, fetchFromGitHub, hostPlatform, buildPlatform }:

stdenv.mkDerivation ({
  name = "musl";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "fab2515090a47461b5f9a0fcd4bcecdeb7803cc7";
    sha256 = "1xw9zbmwzgxx39faj7b94y3xcxdhmv8qd2pqhpwzjs614kkhxyjx";
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
