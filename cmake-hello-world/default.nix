{ fetchFromGitHub, cmake, stdenv }:

stdenv.mkDerivation {
  name = "cmake-hello-world";
  src = fetchFromGitHub {
    owner = "jameskbride";
    repo = "cmake-hello-world";
    rev = "ecc0aa9df71049597a0259841ab74e64579d58be";
    sha256 = "1ps7l2ggzcm6vwvhsrn7s16flalf9frzbnrzwb4c7vdzag0fam1f";
  };
  nativeBuildInputs = [cmake];
}
