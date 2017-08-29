{ stdenv, lib, buildPlatform, hostPlatform, fetchgit }:

stdenv.mkDerivation ({
  name = "musl";
  src = fetchgit {
    url = "git://git.musl-libc.org/musl";
    rev = "8fe1f2d79b275b7f7fb0d41c99e379357df63cd9";
    sha256 = "1675ach4xpylhahrhxcjcsrr49y0ypck2a6k6q7fr5cysyxi1d9g";
  };

  installPhase = ''
    mkdir $out
    make install
    for f in crtbegin crtend crtbeginS crtendS; do
      touch $f.c
      $CC -c -o $out/lib/$f.o $f.c
    done
    for f in libgcc libgcc_s; do
      touch $f.c
      $CC -c -o $f.o $f.c
      ''${AR-ar} rc $out/lib/$f.a $f.o
    done
  '';
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
