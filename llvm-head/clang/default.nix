{ stdenv, sources, cmake, libxml2, libedit, llvm, release_version, python }:

let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  self = stdenv.mkDerivation {
    name = "clang";

    src = sources.clang;

    buildInputs = [ cmake libedit libxml2 llvm python ];

    cmakeFlags = [
      "-DCMAKE_CXX_FLAGS=-std=c++11"
    ] ++
    # Maybe with compiler-rt this won't be needed?
    # (stdenv.lib.optional stdenv.isLinux "-DGCC_INSTALL_PREFIX=${gcc}") ++
    (stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include");

    patches = [ ./purity.patch ./wasm-lld.patch ];

    postPatch = ''
      sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/ToolChains/*.cpp
      sed -i -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/ToolChains/*.cpp
    '';

    outputs = [ "out" "python" ];

    # Clang expects to find LLVMgold in its own prefix
    # Clang expects to find sanitizer libraries in its own prefix
    postInstall = ''
      ln -sv ${llvm}/lib/LLVMgold.so $out/lib
      ln -sv ${llvm}/lib/clang/${release_version}/lib $out/lib/clang/${release_version}/
      ln -sv $out/bin/clang $out/bin/cpp

      mkdir -p $python/bin $python/share/clang/
      mv $out/bin/{git-clang-format,scan-view} $python/bin
      if [ -e $out/bin/set-xcode-analyzer ]; then
        mv $out/bin/set-xcode-analyzer $python/bin
      fi
      mv $out/share/clang/*.py $python/share/clang

      rm $out/bin/c-index-test
    '';

    enableParallelBuilding = true;

    passthru = {
      lib = self; # compatibility with gcc, so that `stdenv.cc.cc.lib` works on both
      isClang = true;
      inherit llvm;
    } // stdenv.lib.optionalAttrs stdenv.isLinux {
      inherit gcc;
    };

    meta = {
      description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
      homepage    = http://llvm.org/;
      license     = stdenv.lib.licenses.ncsa;
      platforms   = stdenv.lib.platforms.all;
    };
  };
in self
