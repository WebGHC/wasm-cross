{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "d24427dcc8cd6e0dbcd8c302eb2e8a5d0d6fdead";
    sha256 = "1bs3a3gzmhx8hyw29mbyq85zmm7c17ap3gsksbd7n09h8r704kh2";
  };
  nativeBuildInputs = [ cmake python ];

  enableParallelBuilding = true;
}
