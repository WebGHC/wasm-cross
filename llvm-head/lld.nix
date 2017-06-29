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
    rev = "5d6fe333454fff48bfef8185580ac3d30265caa9";
    sha256 = "0nb83v2rns253aici9d1gfi8k1wq7xsrsp7dilrii55ap7awdlf1";
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
