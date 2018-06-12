{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "3de179a61e5c29a0f91918da87c692756bc755b4";
    sha256 = "1fksprjs0laqrqmx9mydn2a0qybbbn1k8lmn0dvs1p8x6ik3a0q2";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "e0330b61d74b898ee64922d0a3d50c3562f6ddb1";
    sha256 = "180ld1nlyzlr04sd807jsiyaw4qyj2xw3nk8lc362c838kpzkbra";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "980b901b1e71198925a015eed32e798708fd5674";
    sha256 = "1kc1pb8zrrjg13m0xwl35gllzw9gzhicaril2rnzxx65a88cs6xh";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "40a29e79c29fd5552f44bc7d11e56344b90d0107";
    sha256 = "1jgnr5c8gfyl45ms45kwqm9v14kg2j4k90ywbwdacl9z9amppj3z";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "b620101a53938b86ddeff13f5963f19186586734";
    sha256 = "08d989xk2hqapkdncg83xv0r2471g6syxks0ldg9ida6g6nicxz4";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "829689f693bb14e4e78672f14e50c1e33e65be4e";
    sha256 = "1wf6kxfx528y1rp0vdyy7jshdhca4w31fldq6maph1dp1jysl5gr";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "1e1c6b739595098ba5c466bfe9d58b993e646b48";
    sha256 = "12wpvxchi0nik2xh06j3ivkf9mzg5nmpn87w3cb6dm9lcfh8mv5i";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "4e8e8d6b18fccced6738aa85dfc28105c7add469";
    sha256 = "06al5hn0q30jm3wrq7kggdizl1mv5i50x6ggc0s2lnqn41pab1vb";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "77ec8d7522c5395ab7b2d610e0065e51e819597d";
    sha256 = "11xid9drshfg7m2gl6vdaxi97981rw98ksk5yjjwwjaksj1wyqwy";
  };
}
