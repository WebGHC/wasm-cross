{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "f7a3add6d1392c35ddd42929924d1121b268da6c";
    sha256 = "0j2d4qpcwb4nikmxvgn4zm412yr47fnsja5d3y9cs78j0a3bjm5s";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "d1b3770feaeca4cc32833fd123a14170ef809216";
    sha256 = "1xvnwakasxminwkimqsrbbzw2d0mn1cl1q4zwqqr3j9k547whfi5";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "400a9b139db162e98cf6d3e99162d143ce2ea5bc";
    sha256 = "1ad0pshhkg9f865jx90cdf8h85s132dajmqvjr7z8pz1x4n7zzql";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "a75f2f1e3c2122e7eb077832b065260c963f018f";
    sha256 = "1kfs8cdzhj0lw15pnc64124rlz5n6q4339gf7rd8j1k6iihyx2i6";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "ebd653fe3f40be5782a973f10a9d5ce4999e2fda";
    sha256 = "1yhk19k38h2w28sjvh7j0azgrkpqxd92s5vqz4xcq5ag4yxjghic";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "e0c4412107cdfb3595eed87683984d3f1a6bf841";
    sha256 = "0fzc6b9rpyphavrwkmxz8wxhhimjwrpk5j7yig138qlvwvsb4ar1";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "34ce9473f95bfd007c1ea03a1ee8c3c14cad9233";
    sha256 = "1nmxvlli26kj0xwj3rplmmzx4kdh86iadq4153dg0gi1dhjgl0k5";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "ad3dbbda589b45eb4a70561209b46694e35ea46c";
    sha256 = "0jy88jlhvlmw4d7kmb370y2k086b022psglasa88yazrvd3bjwhi";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "abd5108a573a9a0254ce8d73e57b628e4f206d86";
    sha256 = "0w7y4nihpy0sc0hgz1yk9319yxznj8706s1s3zab0ala1jmcn0fb";
  };
}
