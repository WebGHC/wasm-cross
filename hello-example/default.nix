{ build-wasm-app, stdenv, cmake }:

build-wasm-app ./www (stdenv.mkDerivation {
  name = "hello-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
})
