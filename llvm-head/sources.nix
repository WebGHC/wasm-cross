{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "4446de2c5a3f327eb1780dead5970ad4fa4bc5f0";
    sha256 = "1hdgg2m2f85cqmiq8dqx0z7bxijmg6cq687zpd5ri5f4gp62yphc";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "beab79506950a5f51d9da7d6571b675d88e31211";
    sha256 = "148zq345cw9drgn5mr5ah31fk8n1jcxfxsdafp1hwc21m9icmay6";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "c2f24d9ea8736515030b8900d43b74a452d528a7";
    sha256 = "0bg38si6pb63xdl2ryqfgcl25jd0i6blvlv9dl2nm2g70h23w9wi";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "b525131913352ac4c8c545ece73467e36d51f062";
    sha256 = "1qk3kxr01piqvriwrlyr4d7bsiyk8l7yfdnfp62izbzfij1z3qbx";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "fe2ebf85fa208207acb4289f834ca4f4bf08337f";
    sha256 = "15x57n3afpx2iyrqxc4k9bv5bh65hpxyw5zxhbmrx3wqh8hgnq4z";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "1891c56b4003e05cd4b6e033019d042c8003fc9c";
    sha256 = "1l0wg87860cvw2fvzby8zyapz939573d4sr2cbfr67i5i01y62z1";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "1f736b07f64e00071b6cb0f34e592fe30ab6fa90";
    sha256 = "0iazfxkq5a489rh2hsnvj217kdn0hx321xmmi30h96bgxzr342q1";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "1da06fc8d37ff2abd1da1746e4066d7fd4eaeb07";
    sha256 = "0iskb5a19c1k2wm07hgy75ylx97cl2h6bd4773xzzyrf73ijlhyi";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "36d23ced863bde98de39a88ddf532271418e3216";
    sha256 = "0pbdqmh6csp860ag7bpw2kg4zv2crljvi6nf3zf158ia81xiza82";
  };
}
