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
, cross ? null
}:
let
  callPackage = newScope (self // { inherit stdenv cmake libxml2 python2 isl release_version version fetch-llvm-mirror cross; });

  rev = "301591";
  release_version = "5.0.0";
  version = "r" + rev; # differentiating these is important for rc's

# stdenv.mkDerivation {
#   name = "llvm";
#   version = "head";
#   src = fetchsvn {
#     url = "http://llvm.org/svn/llvm-project/llvm/trunk";
#     rev = "301576";
#     sha256 = "12an2ns3yn7shnpkrnan5zlmjd0wbzaf15xjvad7arw1kkgkhcpi";
#   };

#   buildInputs = [cmake python];
# }
  
  fetch-llvm-mirror = url: fetchurl {
    url = "https://github.com/llvm-mirror/${url.name}/archive/${url.rev}.tar.gz";
    inherit (url) sha256;
  };

  compiler-rt_src = fetch-llvm-mirror {
    name = "compiler-rt";
    rev = "fce320da7a80b1b0f2d1228b9be6a83280315d40";
    sha256 = "1d01dk033mihg0bgpzysahf1mdbnx6kig62briyynmkxq2q9vv50";
  };
  clang-tools-extra_src = fetch-llvm-mirror {
    name = "clang-tools-extra";
    rev = "ba02ce5651e843a93c54e0e319a8887c2292ea8f";
    sha256 = "1v6mzl581cfs5naa1lyng3lvn4na71sqrs3x0qflsqd18nazlrsz";
  };

  self = {
    compiler-rt = callPackage ./compiler-rt.nix { inherit compiler-rt_src; };

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
