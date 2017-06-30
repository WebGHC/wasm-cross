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
    rev = "c46f84251c0ebfa238f72c1841f219d27c12ad0a";
    sha256 = "1ddgmgf11n2q23j0glhj4awky021gja43cnk2dyb30ih8m7406y0";
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
