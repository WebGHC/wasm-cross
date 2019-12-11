{ fetchFromGitHub }:
let
  llvm-project = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "98189755cd98f6e1e22e03e55b951d3ed53a5ae5";
    sha256 = "06l1svzbsdvrvdclizykfm6h2ns3d6r13mbapc18a83ki4j82rli";
  };

in {
  clang = "${llvm-project}/clang";
  libcxxabi = "${llvm-project}/libcxxabi";
  llvm = "${llvm-project}/llvm";
  libcxx = "${llvm-project}/libcxx";
  lldb = "${llvm-project}/lldb";
  clang-tools-extra = "${llvm-project}/clang-tools-extra";
  libunwind = "${llvm-project}/libunwind";
  compiler-rt = "${llvm-project}/compiler-rt";
  lld = "${llvm-project}/lld";
}
