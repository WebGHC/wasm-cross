{ stdenv
, fetch-llvm-mirror
, cmake
, zlib
, llvm
, python
}:

let version = "100ef4f3433d5b0eb8e4f75b51733e3de90e677c";
in stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch-llvm-mirror {
    name = "lld";
    rev = version;
    sha256 = "18baq0kzjqjixnnasc60r87gkbasv3g2g5k4fb4rjfd82kipb1yp";
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
