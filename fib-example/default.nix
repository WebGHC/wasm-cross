{ build-wasm-app, stdenv, cmake }:

build-wasm-app { ename = "fib"; pkg = stdenv.mkDerivation {
  name = "fib-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
}; }
