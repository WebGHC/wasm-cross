{ stdenv
, fetchFromGitHub
, cmake
, zlib
, llvm
, python
}:

stdenv.mkDerivation {
  name = "lld";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "lld";
    rev = "77520876ee4f0c76f03468f375e9f91171a15dcc";
    sha256 = "1gd9d2hirvzvqpj7kjg96sr3ga3a942gyr5dsi9jy33xp3xvzcmz";
  };

  buildInputs = [ cmake llvm ];

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
