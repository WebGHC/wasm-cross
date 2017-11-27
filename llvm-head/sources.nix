{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "9f9177d3ef72580ca29e8844327f63d7aa1908af";
    sha256 = "1ycss5105fh5rg2cv76bvnq0lv16ryad3sdh9r2dm59n38rh9wim";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "5bff412f87e41f24e25e15e8d1739684aa6f0907";
    sha256 = "07vf51r6giaqgwwh62pbc612ybs63zadbsw37wfg8j30kq4xg6s7";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "63c8163add367ed3226777b6267ff57193bbb833";
    sha256 = "19l9yf16fsi5lv4mjp5g781yrplxb80zypfw0wvzx69v56jig9hl";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "14ff89947ca4a6f823ecbbf53af1c7b807d36a41";
    sha256 = "1lrizgjr86vdagh4bqzhcr01sdggqc7vy5pwyxjrwhi7rrqyg332";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "4167c8c09eb3f457ad12ebc3401fc7cde232be5c";
    sha256 = "053zvpm2yfd5476rb4fj7g590vn2dz44v576j6bscv5sfkgy1kqi";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "26568cbcbbbee042174a90165e1f086cb71c26d8";
    sha256 = "1b3v0rilrygy5gs09nrpaf6iwy1pgd4s5wjf6q832wvrygxdvg8i";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "d1b49048d26237c648f339a873e9667e2005668b";
    sha256 = "1prgb2rpjz6n0dncz30724bj14wrps2dr97kyi5i9rgwkyqb8pqv";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "dc8c0dd36ba2c119772ec7e614ca33ec6463214e";
    sha256 = "0x9qq2q6fa9f3c2l5a4rmaqbd9g5ww602lhs78z3gp73483izsm1";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "f50189a449fac45303341bc08e79b96308a57215";
    sha256 = "1hzdi2f25gdcn36ffxd0vdzchiaw0afhb1yjzyvd0jr5fv92a1fs";
  };
}
