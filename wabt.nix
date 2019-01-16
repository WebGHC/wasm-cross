{ stdenv, cmake, python, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "wabt";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    rev = "b37a749c93eb7c716a1a29e99eac63152e4a5d28";
    sha256 = "1ax3zjm07dmi2fvagnh319j13lr02ckdb076inqkb0rqc4z1r74p";
  };
  nativeBuildInputs = [ cmake python ];
  enableParallelBuilding = true;
  cmakeFlags = ["-DBUILD_TESTS=OFF"];
}
