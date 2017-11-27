{ stdenv, lib, buildPackages, fetchFromGitHub, hostPlatform, buildPlatform }:

stdenv.mkDerivation ({
  name = "musl";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "776bf6b906ac4835868f24211150860f8b95fe55";
    sha256 = "0xfmnyfvm3c853d4nv1fam1vk9l5kd7rs33v1wlaydagjbd1b367";
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
