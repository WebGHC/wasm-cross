{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "21e08eeef1ccc489cd06495e4370e1dffccfe088";
    sha256 = "1zyjkjnwg9q7xmk5a6fxmpf925yixbdpz3ia6k00iby3219c3v7s";
  };
  nativeBuildInputs = [ cmake ];
}
