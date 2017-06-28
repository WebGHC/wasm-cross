{ stdenv
, fetch-llvm-mirror
, cmake
, zlib
, llvm
, python
}:

let version = "6ce12b83c0e9c6158c480ef3d9654999947aa1b8";
in stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch-llvm-mirror {
    name = "lld";
    rev = version;
    sha256 = "1d6v53lnsnwgb9df706i5q3dww9mg6ib6mh3scdys2hdvpzr5h6g";
  };

  buildInputs = [ cmake llvm ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = http://lld.llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
