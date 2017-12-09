{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "ce59979560afc7f4cb497bf4b93146e56e607d65";
    sha256 = "1llwixymbwvdfkcdd0s7jaqqgnndzya15hhlpplqzr0f4m8dalg3";
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
    rev = "94240acddc937163335dbd919f2d6833bd9079b0";
    sha256 = "1xabg96rkbpji6nih7jws58nh3r02jw84dnfx6i0zd0028prqx03";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "8148a70b20eb4fa98cafc92f0d4dd6b908951978";
    sha256 = "1mvbpy84vc3c6fcw3kk9dfjyznvh10cwv45m11fnxlrsiimlfqnx";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "03836e919d35ccf227bc459c1bbee1357e7ea63e";
    sha256 = "0ng51yb78zm2d83hs0d99r64w2sj3zj3x38505h9vwkxi8d59s2x";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "e95f20d0df5f2c34c9019bd89ef4a531ca8510be";
    sha256 = "1mbdi8kp5yllivzs7rk9mfmg1ma80w7mwsq8f3xxhm6l23grx0c6";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "7d4a945acea6662fdd75fa80012273e2ac4fa75b";
    sha256 = "05dqxshcjd42klmwv041gxpzyl60ya3n0whyhgd2nd3ziww84bky";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "54a1331a5027f748f0088ef64d010dafc8f6e23e";
    sha256 = "0jq04s15hfadz4qdhzih7gzi29y8k4mqpmz7nhlcxzsjrzcbna7d";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "71a2c05567f9c6cda8c075b238540dd4195a031e";
    sha256 = "1wxr9k9v6il04m0rvlizk4qxp4krnnlhizykvz7p08gkzcbv8djr";
  };
}
