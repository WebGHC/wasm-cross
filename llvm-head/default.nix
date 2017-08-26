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
    inherit stdenv cmake libxml2 python2 isl release_version enableSharedLibraries sources;
  });

  callTool = newScope (tools // libraries // {
    inherit stdenv cmake libxml2 python2 isl release_version enableSharedLibraries sources;
  });

  sources = callLibrary ./sources.nix {};

  release_version = "6.0.0";

  tools = {
    llvm = callTool ./llvm.nix {};

    clang-unwrapped = callTool ./clang {};

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
    in with tools; runCommand "binutils" {} ''
      mkdir -p $out/bin
      # for prog in ${lld}/bin/*; do
      #   ln -s $prog $out/bin/${prefix}$(basename $prog)
      # done
      for prog in ${llvm}/bin/*; do
        ln -s $prog $out/bin/${prefix}$(echo $(basename $prog) | sed -e "s|llvm-||")
      done

      rm $out/bin/${prefix}cat

      ln -s ${lld}/bin/lld $out/bin/${prefix}ld
      ln -s ${lld}/bin/lld $out/bin/${prefix}ld.lld
      ln -s ${lld}/bin/lld $out/bin/${prefix}lld
    '';
  };

  libraries = {
    compiler-rt = callLibrary ./compiler-rt.nix {};

    libunwind = callLibrary ./libunwind.nix {};

    libcxx-headers = runCommand "libcxx-headers" {} ''
      unpackFile ${libraries.libcxx.src}
      mkdir -p $out
      cp -r libcxx*/include $out
    '';

    libcxx = callLibrary ./libc++ {};

    libcxxabi = callLibrary ./libc++abi.nix {};
  };

in { inherit tools libraries; } // tools // libraries
