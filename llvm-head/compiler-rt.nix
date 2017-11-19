{ stdenv
, sources
, cmake
, llvm
, lib
, hostPlatform
, buildPlatform
, python
, baremetal ? false
}:

stdenv.mkDerivation {
  name = "compiler-rt";
  src = sources.compiler-rt;
  nativeBuildInputs = [ cmake python ];
  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${llvm}/bin/llvm-config"
    "-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=${hostPlatform.config}"
  ]
  # TODO: Figure out how to build sanitizers, etc. when cross compiling
  ++ lib.optionals baremetal [
    "--target" "../lib/builtins"
    "-DCOMPILER_RT_BAREMETAL_BUILD=TRUE"
    "-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=TRUE"
  ];

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./projects/compiler-rt/cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'
  '';

  # For some reason, WebAssembly builtins are still placed under a
  # `linux` directory.
  ${if hostPlatform.arch or null == "wasm32" then "installPhase" else null} = ''
    mkdir -p $out/lib
    mv lib/*/libclang_rt.builtins-*.a $out/lib/
  '';

  enableParallelBuilding = true;
}
