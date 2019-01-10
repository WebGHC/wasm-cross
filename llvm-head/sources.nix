{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "1a1eb1e55e1bccc461ae696bc445541f6fef3cd0";
    sha256 = "15xl94p0zrq89qzb4zcpl5xib1qk0mrnlngc7s00fgryg9m481ag";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "307bb62985575b2e3216a8cfd7e122e0574f33a9";
    sha256 = "18a17wsdddknmargb5qx1q5xlcw9gy46iiixqqs5x0klbrs0m66c";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "4196919f29b2f5618b9965e25f04237de75fcfe6";
    sha256 = "195fvn53vv1cq6r8bgvw270m9g6k6mz2f1av8p1m8j3cgz26hc8b";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "9e444eb82d34fd56af3875a6971dead607e20b9e";
    sha256 = "0a80663sad71fag2h2jca44bx2xqw7pmq3mj3c0as1hczjyg2cfw";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "97dbc925cb76dc41da0776381dd9880b6a0e9b98";
    sha256 = "1afq518bnzccg4jzfddf6x16v1hzmdjl5pgwlzwc9x88sqxalnmr";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "8e9fa30d12ff45df47ef8555e7bfa8934d8497d5";
    sha256 = "1py90ypm1k9l098w91660aqnhadb0ggl86203mkry39n45zhj1kc";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "9defb52f575beff21b646e60e63f72ad1ac7cf54";
    sha256 = "0kc5z0lvfg8f90swdg5p2kl4kvmhxbdld876rmfkracdvswvc63r";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "79d27782ac7006e5b2878e7366749769ed6a11f4";
    sha256 = "05m8x5d6d7lk75b2pakvqi5a3vc9bk1miifnj2xndp5dpjypfvrh";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "c9d5567d32d3844ad028ebfd17420ca1fa9f316d";
    sha256 = "1kyk69052sx3mps9ppvb3bl8ybqmpax7bf1kchgsvpcp2ca7c2v6";
  };
}
