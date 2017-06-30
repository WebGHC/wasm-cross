{ newScope
, stdenv
, cmake
, libxml2
, python2
, isl
, fetchurl
, overrideCC
, wrapCC
, ccWrapperFun
, buildTools
, lib
, runCommand
, enableSharedLibraries ? true
, hostPlatform
, targetPlatform
}:
let
  callLibrary = newScope (buildTools.tools // libraries // {
    inherit stdenv cmake libxml2 python2 isl release_version fetch-llvm-mirror enableSharedLibraries;
  });

  callTool = newScope (tools // libraries // {
    inherit stdenv cmake libxml2 python2 isl release_version fetch-llvm-mirror enableSharedLibraries;
  });

  release_version = "5.0.0";

  fetch-llvm-mirror = url: fetchurl {
    url = "https://github.com/llvm-mirror/${url.name}/archive/${url.rev}.tar.gz";
    inherit (url) sha256;
  };

  clang-tools-extra_src = fetch-llvm-mirror {
    name = "clang-tools-extra";
    rev = "a6eb96204517e0cb6051a1456b6f4e4a925ed194";
    sha256 = "18ap6kng86j3p0gc07l0pq1km4cqwnzhl4gxfd482fm8xkqmnyj4";
  };

  tools = {
    llvm = callTool ./llvm.nix {};

    clang-unwrapped = callTool ./clang {
      inherit clang-tools-extra_src;
    };

    clang = wrapCC tools.clang-unwrapped;

    libcxxClang = ccWrapperFun {
      cc = tools.clang-unwrapped;
      isClang = true;
      inherit (tools) stdenv;
      /* FIXME is this right? */
      inherit (stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ libraries.libcxx libraries.libcxxabi ];
    };

    stdenv = overrideCC stdenv tools.clang;

    libcxxStdenv = overrideCC stdenv tools.libcxxClang;

    lld = callTool ./lld.nix {};

    lldb = callTool ./lldb.nix {};

    # Bad binutils based on LLVM
    llvm-binutils = let
      prefix =
        if hostPlatform != targetPlatform
        then "${targetPlatform.config}-"
        else "";
    in with tools; runCommand "binutils" { propogatedNativeBuildInputs = [ llvm lld ]; } ''
      mkdir -p $out/bin
      for prog in ${lld}/bin/*; do
        ln -s $prog $out/bin/${prefix}$(basename $prog)
      done
      for prog in ${llvm}/bin/*; do
        ln -s $prog $out/bin/${prefix}$(echo $(basename $prog) | sed -e "s|llvm-||")
      done

      ln -s ${lld}/bin/lld $out/bin/${prefix}ld
      ln -s ${lld}/bin/lld $out/bin/${prefix}ld.gold # TODO: Figure out the ld.gold thing for GHC
    '';
  };

  libraries = {
    compiler-rt = callLibrary ./compiler-rt.nix {};

    libunwind = callLibrary ./libunwind.nix {};

    libcxx-headers = runCommand "libcxx-headers" {} ''
      unpackFile ${libraries.libcxx.src}
      mkdir -p $out
      mv libcxx*/include $out
    '';

    libcxx = callLibrary ./libc++ {};

    libcxxabi = callLibrary ./libc++abi.nix {};
  };

in { inherit tools libraries; } // tools // libraries
