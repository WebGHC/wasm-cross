{ stdenv
, sources
, cmake
, llvm
, hostPlatform
, buildPlatform
, lib
, libcxx-headers
}:
stdenv.mkDerivation {
  name = "libunwind";
  src = sources.libunwind;
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
