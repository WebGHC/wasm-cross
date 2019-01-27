{ stdenv
, sources
, fetchpatch
, perl
, groff
, cmake
, python
, libffi
, libbfd
, buildPackages
, libxml2
, valgrind
, ncurses
, release_version
, zlib
, libcxxabi
, debugVersion
, enableSharedLibraries
, darwin
}:

let
  shlib = if stdenv.isDarwin then "dylib" else "so";

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with stdenv.lib;
    concatStringsSep "." (take 2 (splitString "." release_version));
in stdenv.mkDerivation rec {
  name = "llvm";

  src = sources.llvm;

  outputs = ["out"] ++ stdenv.lib.optional enableSharedLibraries "lib";

  buildInputs = [ perl groff cmake libxml2 python libffi ];

  propagatedBuildInputs = [ ncurses zlib ];

  # Most people build LLVM in the monolithic 'projects' form. So most
  # people don't notice when LLD imports an internal header...
  patches = [./llvm-config.patch ./isFAbsFree.patch];

  postPatch = stdenv.lib.optionalString (enableSharedLibraries) ''
    substitute '${./llvm-outputs.patch}' ./llvm-outputs.patch --subst-var lib
    patch -p1 < ./llvm-outputs.patch
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; lib.optional debugVersion
    "-DCMAKE_BUILD_TYPE=Debug"
  ++ [
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly"
  ] ++ stdenv.lib.optional enableSharedLibraries [
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ] ++ stdenv.lib.optional (!isDarwin)
    # TODO: Not sure what binutils to use here
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    ++ stdenv.lib.optionals (isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ];

  postBuild = ''
    rm -fR $out

    paxmark m bin/{lli,llvm-rtdyld}
    paxmark m unittests/ExecutionEngine/MCJIT/MCJITTests
    paxmark m unittests/ExecutionEngine/Orc/OrcJITTests
    paxmark m unittests/Support/SupportTests
    paxmark m bin/lli-child-target
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
  '';


  postInstall = stdenv.lib.optionalString enableSharedLibraries ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM${stdenv.hostPlatform.extensions.sharedLibrary}" "$lib"
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  '';


  # postInstall = ""
  # + stdenv.lib.optionalString (enableSharedLibraries) ''
  #   moveToOutput "lib/libLLVM-*" "$lib"
  #   moveToOutput "lib/libLLVM.${shlib}" "$lib"
  #   substituteInPlace "$out/lib/cmake/llvm/LLVMExports-release.cmake" \
  #     --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  # ''
  # + stdenv.lib.optionalString (stdenv.isDarwin && enableSharedLibraries) ''
  #   substituteInPlace "$out/lib/cmake/llvm/LLVMExports-release.cmake" \
  #     --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
  #   install_name_tool -id $lib/lib/libLLVM.dylib $lib/lib/libLLVM.dylib
  #   install_name_tool -change @rpath/libLLVM.dylib $lib/lib/libLLVM.dylib $out/bin/llvm-config
  #   ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
  #   ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  # '';

  doCheck = false; # stdenv.isLinux;

  dontStrip = debugVersion;

  checkTarget = "check-all";

  enableParallelBuilding = true;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin viric dtzWill ];
    platforms   = stdenv.lib.platforms.all;
  };
}
