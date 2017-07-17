{ stdenv, lib, buildPackages, fetchgit }:

stdenv.mkDerivation {
  name = "musl";
  src = fetchgit {
    url = "https://github.com/WebGHC/wasm-syslib-builder";
    rev = "cc5b9cdb7479db3ad781a01d4f21d4dfa46e6adc";
    sha256 = "1445a537y0jdf61cc68nrw65iljqv20p3ddv8qb8zqi8q49n0gfl";
  };
  phases = ["unpackPhase" "buildPhase" "installPhase"];
  nativeBuildInputs = [buildPackages.python];
  hardeningDisable = ["pic"];

  buildPhase = ''
    python libbuild.py
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/include

    cp `pwd`/lib/libc.a $out/lib
    cp -r `pwd`/emscripten/system/include/libc/* $out/include
    rm $out/include/bits # This comes from arch/emscripten
    cp -r `pwd`/emscripten/system/include/emscripten.h $out/include
    cp -r `pwd`/emscripten/system/include/emscripten/* $out/include
    cp -r `pwd`/emscripten/system/lib/libc/musl/arch/emscripten/* $out/include
  '';
}
