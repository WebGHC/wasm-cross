{ stdenv
, sources
, cmake
, libxml2
, llvm
, version
, debugVersion
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = sources.lld;


  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm libxml2 ];

  cmakeFlags = stdenv.lib.optional debugVersion "-DCMAKE_BUILD_TYPE=Debug";

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
