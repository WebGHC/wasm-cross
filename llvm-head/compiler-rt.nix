{ stdenv, compiler-rt_src, cmake, llvm, python, cross ? null }:

stdenv.mkDerivation {
  name = "compiler-rt";
  src = compiler-rt_src;
  nativeBuildInputs = [ cmake llvm python ];

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./projects/compiler-rt/cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'
  '';

  cmakeFlags = [ "-DCOMPILER_RT_INCLUDE_TESTS=OFF" ]; # FIXME: requires clang source code
}
