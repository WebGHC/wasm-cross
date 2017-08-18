{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "binaryen";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "5fafb87a2819cebd94941c77c07ebe067471eb7d";
    sha256 = "1hfkz6q4k99qz0hhbygdfwqnsf0rdjghbj1bqy25zamsbmzq67ch";
  };
  nativeBuildInputs = [ cmake ];

  # Binaryen (correctly) fails on symbols with the same
  # name. Something is outputting multiple `dummy` symbols when you
  # call a big enough libc function (like `printf`, as long as your
  # call can't be optimized to `puts`), which works fine as far as the
  # browser is concerned, since it only cares about the numeric
  # identifier. But to inspect such wasm, we have to patch binaryen to
  # produce (invalid) disassembly in this case. Considering binaryen
  # has no part in our toolchain currently, this is acceptable.
  patches = [./binaryen.patch];
}
