{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "bf81db4ab70b45a77fba0d9f7d43190f1ad91bb9";
    sha256 = "064b3ixzn92kj0fh5gyrcj6afzr0h2f1zj2b7jwgc5phm77k9vh6";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "52c7a3760aef1df328a9bc957f686410872f0dc0";
    sha256 = "1aam539j01381q27b7xhij18pz3h0lhw08hglvqq4hgvlqx5cn2s";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "b7ab0ed2197b34dd9665e9c6ab417f375887f571";
    sha256 = "04sx39mm6hgp0f35c6k0jv8n0rgg9pldcfhxx5is8507w2gwppl2";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "ed744ac69bbfaa31fae98ecebefe4c3015f256d8";
    sha256 = "14b8vr0w990ljhn353a2vfzy9606jwx0shnhq13dzck1smcb7w3j";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "a2fb02709e91f106da51277b4be1bce114879f91";
    sha256 = "1qpx5753d35fnz38yp9vglvfc6gwg3n8zg418al8v08f49masq78";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "ce2e6ffb77dc11a43d177bea8131e78afb829da7";
    sha256 = "16gaad4hw717sm932jjsj132b6b9hndy9dvdb0q7ba3g20zha2sv";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "0f3cbe4123f8afacd646bd4f5414aa6528ef8129";
    sha256 = "1swdfqr9jgjhip7071n1p3x4rpqyv4qyvqkrzh7n0m40zibrpx4v";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "fe404ca10611902b252d7c190288eb32af8dfc4a";
    sha256 = "1kwfga9k9mxiipyfkgxclddq54rids3j9xbg7s2ljbv6c1igcf7m";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "3fa88b5410bcf06c353849ef5fe29fbffcef8147";
    sha256 = "1j67bsxlyqs727x03v3p2m5sig6hl5r24vy2afsbp6nqifd8yvh6";
  };
}
