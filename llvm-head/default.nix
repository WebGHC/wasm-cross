{ newScope
, stdenv
, cmake
, libxml2
, python2
, isl
, fetchurl
, overrideCC
, wrapCC
, darwin
, ccWrapperFun
}:
let
  callPackage = newScope (self // { inherit stdenv cmake libxml2 python2 isl release_version version fetch-llvm-mirror; });

  rev = "301591";
  release_version = "5.0.0";
  version = "r" + rev; # differentiating these is important for rc's

  fetch-llvm-mirror = url: fetchurl {
    url = "https://github.com/llvm-mirror/${url.name}/archive/${url.rev}.tar.gz";
    inherit (url) sha256;
  };

  clang-tools-extra_src = fetch-llvm-mirror {
    name = "clang-tools-extra";
    rev = "05cb0e144a998cc4a016097e50ca8090e7ac7b5a";
    sha256 = "0wdjk7z6gi9znsswzw956jsdsl6gb54n99ck4pybjkm0jdjik40k";
  };

  self = {
    compiler-rt_src = fetch-llvm-mirror {
      name = "compiler-rt";
      rev = "9cbbe014c4d99e31fce00f40cfbecf3799872d2e";
      sha256 = "05ndndq8sp317ig2fh88xvm6ps7whf5sy9slwfkl0s88m2k79jjp";
    };

    llvm = callPackage ./llvm.nix {
      inherit stdenv;
    };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src stdenv;
    };

    clang = wrapCC self.clang-unwrapped;

    libcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      isClang = true;
      inherit (self) stdenv;
      /* FIXME is this right? */
      inherit (stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ self.libcxx self.libcxxabi ];
    };

    stdenv = overrideCC stdenv self.clang;

    libcxxStdenv = overrideCC stdenv self.libcxxClang;

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
