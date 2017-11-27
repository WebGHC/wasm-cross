{ build-wasm-app, stdenv, cmake, musl-cross }:

build-wasm-app ./www (stdenv.mkDerivation {
  name = "hello-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
})
