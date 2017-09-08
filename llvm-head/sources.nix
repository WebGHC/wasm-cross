{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "51a7f4d7ba9889b25b20c23d28aa0c142ff2a830";
    sha256 = "1hn3r3xgp9yf31n17f0pq8pgx5rv3ap547lcfcs2s5h6ahkzk5x1";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "caa78daf9285dada17e3e6b8aebcf7d128427f83";
    sha256 = "1jqjgkfsfqjf6j4laqn88qjm7dmnfw50xwdp7y4qgrvhlzynz66g";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "fe2090ab78d06b3d29b9e4ee72669319ec35d775";
    sha256 = "0anizlzjqkf5a2981vzzkqjw3piyf4rsdj3gbhnszbikavj5y0k1";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "11762b4acd1fc19fb8f6d0015b339ad6b9c8f2f5";
    sha256 = "006z4w25izyw7aqaf7h20m2nc9b8zivha1869mdpyi8irddryicj";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "1aada11780684fdfa3c92ef85f20138f244f2bf2";
    sha256 = "1sjs2yim4h1s4j7iaz3a6xmw5l9nscghh9qnf42z57kzpkc1wimf";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "031926737f73aa9184fbca00b0fdbff3765298ab";
    sha256 = "165dmsv83r8s63mq6m6qyfk2zg3j45jgzcq3mpcrxj09p4qxxxqr";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "469bacd2ea64679c15bb4d86adf000f2f2c27328";
    sha256 = "0cav2zb1j56i3lvld1l9gv022djpirhj75hnx2cnai0bc2jscxqa";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "c6ca7345fbe67ac3b1ea5a23b75daea5a019814f";
    sha256 = "151db9y4044qhrasii2bxcbapi3c39ycha49qhix3nhkl2ncpw5k";
  };
  lld = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "lld";
    rev = "85cf5f035718d653a6c1e3e4613fd06c8f0e731c";
    sha256 = "1304pksscvj46whx1xjvs8gqcxzk23sbb10krhac8r6nzacd0pi6";
  };
}
