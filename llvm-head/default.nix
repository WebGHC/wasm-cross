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
}:
let
  callPackage = newScope (buildTools.tools // libraries // {
    inherit stdenv cmake libxml2 python2 isl release_version fetch-llvm-mirror;
  });

  release_version = "5.0.0";

  fetch-llvm-mirror = url: fetchurl {
    url = "https://github.com/llvm-mirror/${url.name}/archive/${url.rev}.tar.gz";
    inherit (url) sha256;
  };

  clang-tools-extra_src = fetch-llvm-mirror {
    name = "clang-tools-extra";
    rev = "05cb0e144a998cc4a016097e50ca8090e7ac7b5a";
    sha256 = "0wdjk7z6gi9znsswzw956jsdsl6gb54n99ck4pybjkm0jdjik40k";
  };

  compiler-rt_src = fetch-llvm-mirror {
    name = "compiler-rt";
    rev = "9cbbe014c4d99e31fce00f40cfbecf3799872d2e";
    sha256 = "05ndndq8sp317ig2fh88xvm6ps7whf5sy9slwfkl0s88m2k79jjp";
  };

  tools = {
    llvm = callPackage ./llvm.nix { inherit compiler-rt_src; };

    clang-unwrapped = callPackage ./clang {
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

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};
  };

  libraries = {
    compiler-rt = callPackage ./compiler-rt.nix { inherit compiler-rt_src; };

    libunwind = callPackage ./libunwind.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };

in { inherit tools libraries; } // tools // libraries
