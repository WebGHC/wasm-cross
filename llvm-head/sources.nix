{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "f1010cd2b085546ee8d1902e432bcb3238117bcd";
    sha256 = "1abldwfn5a6y79d4jfkxbaqd91v4afcy42sqknmrygvln4jys515";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "d4dc2dd4696ddc4ccc5fe2ba3fcd4f52564bdd44";
    sha256 = "1fkgmahizl0p9q8kqk3ddyds8jgspf06mpwmybyjfksjfnsn67l5";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "0edb3bf17dbb212ecb5bd75d14a77f208c673362";
    sha256 = "1hv81gn9sw85nkghz7c9fc8lf302pg3cinl5h1hig5s40ndmq0nd";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "862878bc38e0a73e91470e455b45555ad97ea2c3";
    sha256 = "0ajca4is9khs8nzdnnsdn80a7amcm30w1cc85vsppms6va3jl6rj";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "64af8b42a264d53422f1a5cbddacb7ffc48a39cd";
    sha256 = "18bjdjrpbyrfli9nxp0hzbj15abki11ivmavpc7szwq2igpvv1bl";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "ef5cc8ef6ef3b27c1bc56cd1290250b75980b78d";
    sha256 = "1dmcn2vqw5cglvh2avcfjcj02iim9l9ciqn9ss9h852l8gma0xiq";
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
    rev = "5e41b2de58812e793f0d03c0aa16126522888338";
    sha256 = "00qnkqw2ak8s92930q6zlkm1gc3w5mxy0g1bz3qgpglq8f73a2xh";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "b30ed4cb66e5b3f139c2270a1d5636189acd597f";
    sha256 = "1hygd5vah2ad5qwcx38a185hkrha0dzqslicfwr7agn2nlhk6bid";
  };
}
