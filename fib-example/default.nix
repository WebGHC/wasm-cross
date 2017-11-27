{ build-wasm-app, stdenv, cmake, musl-cross }:

build-wasm-app ./www (stdenv.mkDerivation {
  name = "fib-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
})
