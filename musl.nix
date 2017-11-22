{ stdenv, lib, buildPackages, fetchFromGitHub, hostPlatform, buildPlatform }:

stdenv.mkDerivation ({
  name = "musl";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "musl";
    rev = "b9f4f6a9835b57b8f3325ab6dcd1c715a2eb1ce0";
    sha256 = "0ss41ky0xgq3ph6jv809xwn3lq1gakw66hb4sriqxp6nadvw9gzs";
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
