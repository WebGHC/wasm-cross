{ build-wasm-app, stdenv, cmake }:

build-wasm-app ./www (stdenv.mkDerivation {
  name ="free-example";
  src = ./.;
  nativeBuildInputs = [ cmake ];
  hardeningDisable = [ "fortify"];
})
