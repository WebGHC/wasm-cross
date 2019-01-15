{ build-wasm-app, stdenv, cmake }:

build-wasm-app "fib" (stdenv.mkDerivation {
  name = "fib-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
})
