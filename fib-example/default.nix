{ build-wasm-app, stdenv, cmake }:

build-wasm-app ./www (stdenv.mkDerivation {
  name = "fib-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
})
