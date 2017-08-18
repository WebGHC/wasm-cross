{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "5fafb87a2819cebd94941c77c07ebe067471eb7d";
    sha256 = "1hfkz6q4k99qz0hhbygdfwqnsf0rdjghbj1bqy25zamsbmzq67ch";
  };
  nativeBuildInputs = [ cmake ];
}
