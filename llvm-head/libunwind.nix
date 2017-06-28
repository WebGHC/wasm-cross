{ stdenv
, fetch-llvm-mirror
, cmake
, llvm
, hostPlatform
, buildPlatform
, lib
, libcxx-headers
}:
stdenv.mkDerivation {
  name = "libunwind";
  src = fetch-llvm-mirror {
    name = "libunwind";
    rev = "41f982e5887185b904a456e20dfcd58e6be6cc19";
    sha256 = "17b1fy09rgbrbn1i6hfzabf4a8bppj46zx651sjbhc0cgfdlhq6q";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libcxx-headers ];
  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${llvm}/bin/llvm-config"
    "-DLIBUNWIND_TARGET_TRIPLE=${hostPlatform.config}"
    "-DCMAKE_CXX_FLAGS=-I${libcxx-headers}/include"
    "-DLLVM_NO_OLD_LIBSTDCXX=TRUE"
  ] ++ lib.optionals (hostPlatform != buildPlatform) [
    "-DUNIX=TRUE" # TODO: Figure out what this is about
  ];

  postInstall = ''
    cp -r ../include $out
  '';
}
