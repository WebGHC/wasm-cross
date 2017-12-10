{ stdenv
, fetchFromGitHub
, cmake
, zlib
, llvm
, python
, libxml2
, sources
, debugVersion
}:

stdenv.mkDerivation {
  name = "lld";

  src = sources.lld;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = stdenv.lib.optional debugVersion "-DCMAKE_BUILD_TYPE=Debug";

  dontStrip = debugVersion;

  buildInputs = [ llvm libxml2 ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = http://lld.llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
