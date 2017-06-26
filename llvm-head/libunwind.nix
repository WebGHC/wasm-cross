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
    rev = "da5936d515cf12d2776a336a928940471147244d";
    sha256 = "0sbgy1qmggyijb4axksm6chiq3ymyaay5ndjidbf6qq9s0ad1ybd";
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
