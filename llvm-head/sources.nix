{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "e9d22cbcf2d884c08c779ce0958fd70607032494";
    sha256 = "0r7bk7kj97gnaq0vpnh5lpj4cw6ldin4nnf9y4a3pj6cphllh9vf";
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
    rev = "c1e866c7f106668016372d945e397d2b003c6c84";
    sha256 = "1211rj5lfdippwr95r1kcdc9455syl2568jaf10jw8mr8477mlpm";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "327f3b7eff3fa8fd8bdec09663cab2cbc76c67b9";
    sha256 = "045cbgakb4hcyyvwxdwi8cl3x5yjbfbn39z7awj1q0vn2msjibgk";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "65022807611974be59c84237534b953de44936ff";
    sha256 = "18vr11gzqcmrbmnilp3w49r7c4kja696bhh0f9bx3ai5gpqw48sm";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "ec68612007cfed416a878a20fea11e50ff18ad5b";
    sha256 = "0hn7hz3g3jsrpn31jz23jnbzswgx9lbfwpbvaij2xxpiny2ah1q6";
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
    rev = "4b38c4038a4f2b8e2d02b5f5d7877fa79d940009";
    sha256 = "1pcqdk42knxq3c0sv0rbshyc1f44f1xwjphcvws9w9h4hb0ficnn";
  };
  lld = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "lld";
    rev = "3f43b0f6c2790409a7573259580d5a548467947a";
    sha256 = "12xzjhz39d7qq57dx898s78a7v5xrm9gc3zbqhvzcy5q32r87724";
  };
}
