{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "07b412d4eed907c22ca8d28e609dafb8a5490d41";
    sha256 = "1f8czh38kxkb1z3lcz5svj86nyfblf1nxwwrinn08mhxhnsl11ky";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "7e027acf6917a3b90159b1b4b8a800f0d20bf6f8";
    sha256 = "1pnwiykr476pr76gq6cg5ri615ysixb0i7r67c59v4wk5gbnmd67";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "193aea3782308c66a7a12f1c37520a1b4ff1dbd8";
    sha256 = "0y790riggp4mil4cmjajnqd61v4pz1arq7gi0xpn198rjmyic7g4";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "f31b30dc555601e103a07ebeb6028ce7bf7e350d";
    sha256 = "17i91kzwc00wqdfxx4a2dch9h0ijzjx3rk5lqrx2lz3nf8lx7fs6";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "baea95d4ae0fac914f1e327f5e532920078be391";
    sha256 = "1wcrnyd1cpvml1b0xz7h4z82p5503swhlqr5xq2282i4yfx4yah9";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "73995c3e3ef234ddca737a8698a9649d6ef63abb";
    sha256 = "1wsx29cacmw7h9q2gysra1w5ar889cmd4vjfz25psqzlcym5mfd0";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "d550d634cd38e02f4693e844f2ce2be2a65d14c5";
    sha256 = "091v9x918zs2d3aqx03bbc6zaix3jy2ygw9z96l8990qj6fmc02b";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "6739538786f25e71206d34d7bd65d016b9d27d4d";
    sha256 = "1f8hizd5rif1nzwwji8nk71fcgyzllmb6yabzl1jg6x5zkxq2ilb";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "aa25aeb2ca79118efd00172a76a4c70af68f9e4a";
    sha256 = "012cnn3rkqqsmbyzy01yai7535xnxlmf1xpbyyv4lql6np2a4ry3";
  };
}
