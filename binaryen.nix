{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "e42e1e3d4a5c67c0c066fe397b456ab8d41a78fd";
    sha256 = "038c244n7wdilzq3lmfpj7lahhd0ga7g0v238sh7hhjkjgd1rndf";
  };
  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;
}
