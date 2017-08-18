{ stdenv, lib, buildPackages, fetchgit }:

stdenv.mkDerivation {
  name = "musl";
  src = fetchgit {
    url = "https://github.com/WebGHC/wasm-syslib-builder";
    rev = "ae1446d70619e6b5f99fa49fe34cc23264d46d7e";
    sha256 = "1zp43pf5yg2vrc1c3w29vfv2xrjk788h58lfqxf0ww78ifpr6kal";
  };
}
