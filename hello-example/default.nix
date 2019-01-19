{ build-wasm-app, stdenv, cmake }:

build-wasm-app { ename = "hello"; pkg = stdenv.mkDerivation {
  name = "hello-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
}; }
