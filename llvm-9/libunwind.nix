{ stdenv, version, sources, cmake, fetchpatch, enableShared ? true }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = sources.libunwind;

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
