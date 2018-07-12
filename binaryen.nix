{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "14ea9995281718b9694db4ed5441d44d1171e86f";
    sha256 = "0hsh1ghma06qlq9xhz9lv1gs2ysgf0px5dfbrf24i2hlbfbcm7la";
  };
  nativeBuildInputs = [ cmake python ];

  enableParallelBuilding = true;
}
