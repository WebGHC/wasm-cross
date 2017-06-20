{ stdenv, fetch-llvm-mirror, cmake, libxml2, libedit, llvm, release_version, clang-tools-extra_src, python }:

let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  version = "cdc846bf68eaeabea7f515b0daa3657777924c0f";
  src = fetch-llvm-mirror {
    name = "clang";
    rev = version;
    sha256 = "0yy3crkkwzxll48rdl3j8kiq7jlb3cx3dgznmirjxavxf0q2s0rd";
  };
  self = stdenv.mkDerivation {
    name = "clang-${version}";

    unpackPhase = ''
      unpackFile ${src}
      mv clang-${version}* clang
      # cp --no-preserve=mode -r ${src} clang
      sourceRoot=$PWD/clang
      unpackFile ${clang-tools-extra_src}
      mv clang-tools-extra-* $sourceRoot/tools/extra
      # cp --no-preserve=mode -r ${clang-tools-extra_src} $sourceRoot/tools/extra
    '';

    buildInputs = [ cmake libedit libxml2 llvm python ];

    cmakeFlags = [
      "-DCMAKE_CXX_FLAGS=-std=c++11"
    ] ++
    # Maybe with compiler-rt this won't be needed?
    (stdenv.lib.optional stdenv.isLinux "-DGCC_INSTALL_PREFIX=${gcc}") ++
    (stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include");

    patches = [ ./purity.patch ];

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
