{ stdenv
, fetch-llvm-mirror
, cmake
, llvm
, hostPlatform
, buildPlatform
, lib
}:
stdenv.mkDerivation {
  name = "libunwind";
  src = fetch-llvm-mirror {
    name = "libunwind";
    rev = "da5936d515cf12d2776a336a928940471147244d";
    sha256 = "0sbgy1qmggyijb4axksm6chiq3ymyaay5ndjidbf6qq9s0ad1ybd";
  };
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${llvm}/bin/llvm-config"
    "-DUNIX=TRUE" # TODO: Figure out what this is about
    "-DLIBUNWIND_TARGET_TRIPLE=${hostPlatform.config}"
  ]
  ++ lib.optional (hostPlatform != buildPlatform) "-DLLVM_NO_OLD_LIBSTDCXX=TRUE";
}
