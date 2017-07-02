{ stdenv, cmake }:

stdenv.mkDerivation {
  name = "fib-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
}
