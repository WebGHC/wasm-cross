{ stdenv, cmake, python, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "wabt";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    rev = "be94d802c076c08d8f102eb4c6d3376dcc77c232";
    sha256 = "08rnwv5is6vd0xqjqykjd7k4c0apmz9asvjg1m22dpz6milrwnmd";
  };
  nativeBuildInputs = [ cmake python ];
  enableParallelBuilding = true;
  cmakeFlags = ["-DBUILD_TESTS=OFF"];
}
