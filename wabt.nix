{ stdenv, cmake, python, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "wabt";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    rev = "c1896e079897830b4e8c8f9c15dea6bd41ffc28c";
    sha256 = "03x2imhs43p4iwjhgwgh925r2b43mgscml5wpg6wcqa7zhqacnzs";
  };
  nativeBuildInputs = [ cmake python ];
  enableParallelBuilding = true;
  cmakeFlags = ["-DBUILD_TESTS=OFF"];
}
