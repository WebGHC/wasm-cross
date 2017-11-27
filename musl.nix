{ stdenv, lib, buildPackages, fetchFromGitHub, hostPlatform, buildPlatform }:

stdenv.mkDerivation ({
  name = "musl";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "a96d25da0d7ed6168efe043d31c8c657eb7ff1fa";
    sha256 = "1qb6a0hhkfqmipyfxn4q1vkgg83l041j8advxp6zb4xwis0bvlkn";
  };

  postInstall = ''
    for f in crtbegin crtend crtbeginS crtendS; do
      touch $f.c
      $CC -c -o $out/lib/$f.o $f.c
    done
  '' + lib.optionalString (hostPlatform.arch or null == "wasm32") ''
    cp $src/arch/wasm32/wasm.syms $out/lib/wasm.syms
  '';

  enableParallelBuilding = true;
} // lib.optionalAttrs (hostPlatform != buildPlatform) {
  CROSS_COMPILE = "${hostPlatform.config}-";
})
