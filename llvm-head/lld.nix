{ stdenv
, fetchFromGitHub
, cmake
, zlib
, llvm
, python
, libxml2
# , sources
}:

stdenv.mkDerivation {
  name = "lld";

  # src = sources.lld;

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "lld";
    rev = "56a0a0e7eb2c72fbdcf5912255232742443738dd";
    sha256 = "0i43n1lr5i119nn8gfw2f6vzlqkgj763rppw194byy83qqsjn110";
  };

  nativeBuildInputs = [ cmake ];

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
