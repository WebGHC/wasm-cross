{ fetch-llvm-mirror }: {
  llvm = fetch-llvm-mirror {
    name = "llvm";
    rev = "3fa112e64591985e38b8eba2d7da91e8af32e48d";
    sha256 = "1953167di1ipbp34x2qg2dasfy50n7rw31fmh0z8fyp1yrz29vac";
  };
  clang = fetch-llvm-mirror {
    name = "clang";
    rev = "9d04204d2a2c73b58e8a8d20bcb4f514da273ca3";
    sha256 = "1lzjpnzp7rbxkfnxj9sq7il5lgyhbnw75l4s20qny4zjpxwbsif8";
  };
  lld = fetch-llvm-mirror {
    name = "lld";
    rev = "bf23124dcec48c6be9d66cc10572cca1475b738d";
    sha256 = "1z5x6a5f6qipk6z97qa0ppxxc4lhcxjqg50dv0xpwykj946f60pv";
  };
  clang-tools-extra = fetch-llvm-mirror {
    name = "clang-tools-extra";
    rev = "54c46b27ee3c2c784fa06266f6ed6b9e16c85388";
    sha256 = "06by23yzjjx4ajyzvb74p9vpdr0nab37clasp35r7qpcxrf1lc4b";
  };
  compiler-rt = fetch-llvm-mirror {
    name = "compiler-rt";
    rev = "ecbdaaaa7a191059b66291b93f6874e7189e4ed9";
    sha256 = "1x40r0v24ix509z733pylgi6380a1q37jzjbw16jqcxwbsz8gb5a";
  };
  libcxx = fetch-llvm-mirror {
    name = "libcxx";
    rev = "d08ba82b09f62a34c5f0b22a4acdba607df8313e";
    sha256 = "0kzpdbhs5zxy6dl4wrdri6pv72l2fgw314w9zsigyvs2qgh364hx";
  };
  libcxxabi = fetch-llvm-mirror {
    name = "libcxxabi";
    rev = "139ba7b511399914f830bc4f286c1f4c256e7dea";
    sha256 = "1nqqb9fvm12558kg8wvc2sq2lbz3gnm7dhsp2y3z8gc468nfnb8z";
  };
  libunwind = fetch-llvm-mirror {
    name = "libunwind";
    rev = "82c7974db48aeaa36b51e364ba5a5cd25b3f4f54";
    sha256 = "1b38vzbk40q1yf5ww9rlj9nhz2p428ixx8k4jb1005xrghxhpsik";
  };
  lldb = fetch-llvm-mirror {
    name = "lldb";
    rev = "97acfd7105f23494e4a96a1d203b2a196ee3e8d0";
    sha256 = "0ac5pv95cs4qn73k44r734xg51x9iq2r7iwbg6xb1ggnfpv5kb0y";
  };
}
