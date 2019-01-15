{ build-wasm-app, stdenv, cmake }:

build-wasm-app "hello" (stdenv.mkDerivation {
  name = "hello-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
})
