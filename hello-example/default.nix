{ buildEnv, stdenv, cmake, musl-cross }:

let
  hello = stdenv.mkDerivation {
    name = "hello-example";
    src = ./.;
    nativeBuildInputs = [ cmake ];
  };
in buildEnv {
  name = "hello-example";
  paths = [
    ./www
    "${musl-cross.src}/arch/wasm32/js"
    "${hello}/bin"
  ];
}
