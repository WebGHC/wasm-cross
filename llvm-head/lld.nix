{ stdenv
, fetchFromGitHub
, cmake
, zlib
, llvm
, python
}:

stdenv.mkDerivation {
  name = "lld";

  src = fetchFromGitHub {
    owner = "WebGHC";
    repo = "lld";
    rev = "3fb3b8fec2259815f6293410beb16d3e3493e5ec";
    sha256 = "14vd7rjc1wgklp99dc33ihmk9n62c9xhfy6wlpb0waa9myz9vhr6";
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
