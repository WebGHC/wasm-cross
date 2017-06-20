{ stdenv
, fetch-llvm-mirror
, cmake
, zlib
, llvm
, python
}:

let version = "e94f5a7bf2bf685663c3346cd91b6591571bf00d";
in stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch-llvm-mirror {
    name = "lld";
    rev = version;
    sha256 = "1wn4sfd2l1lyrizdaw4v1wx5ssr7brgf7rinyskxq325j0syb87m";
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
