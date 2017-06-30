{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "e488da5adbef2613c08fe205db5b79b1765a4af3";
    sha256 = "0sk6gs2gx1fwksif47b5pcb7z4x1mdmbh284k90qapy86g071gg2";
  };
  nativeBuildInputs = [ cmake ];
}
