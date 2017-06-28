{ stdenv, lib, buildEnv, buildPackages }:

let
  binaryen = buildPackages.callPackage ./binaryen.nix {};
  clang-llvm = buildEnv {
    name = "clang-llvm";
    paths = [ stdenv.cc.cc stdenv.cc.cc.llvm ];
    pathsToLink = [ "/bin" ];
  };
in stdenv.mkDerivation {
  name = "musl";
  src = lib.cleanSource ./musl;
  phases = ["unpackPhase" "buildPhase" "installPhase"];
  nativeBuildInputs = [buildPackages.python binaryen clang-llvm];

  buildPhase = ''
    python libc.py --compile-to-wasm --clang_dir ${clang-llvm}/bin --musl `pwd` --binaryen_dir ${binaryen}/bin --verbose -o `pwd`/libc.a
  '';
  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/include

    cp ./libc.a $out/lib
    cp -r ./include/* $out/include
    cp -r ./arch/wasm32/* $out/include
  '';
}
