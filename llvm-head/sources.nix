{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "d80246686d6ad2a749d11470afbbd1bbe4d1b561";
    sha256 = "1yvy9jsd6w3q7rk04ixrv3b3nyrxfm1g1m2s3l67ya84b248ppsv";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "43600b48fcd9201db390d94ffcce2625c5925f07";
    sha256 = "1qxrg0v5x0f9lzi4cq4mq9rrb65ffnsgdlgdc9z2ahvhx37pcdd9";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "0c61ae7978a8010c67fc22931849300da50f4b62";
    sha256 = "14iydksqp6hkbvw3j3sw7rv91b6xmh4dflw4g8pq544n0m0yw019";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "d316c2b7fcb3ccfe24f008081b83f9040f71be0d";
    sha256 = "0lj82s4k6gyvjwq6v0jacbm212v3b0aic0w0kl6zw9gsy313vx9l";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "48dec69bcd5a0dc5c415f4646fe9b408726f52e7";
    sha256 = "1shn23jv1l75npdkaf3jvxl8hdzdgf8dqmsd1hnf6a5mas8l4975";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "7007ecbdf850ee13a339db8ee37a8b439a99e544";
    sha256 = "0yyl4fg01prfkin4l7fpp28w8g7l1bjciycs55yg4ymkcfwg6fg6";
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
    rev = "c04177df4d16e8efb33de7c31c2b53187e50a876";
    sha256 = "1mrl86sw3yngfvfcfcfgjalg9i451j5waz8x3nj5vgmsyzykrr7g";
  };
  lld = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "lld";
    rev = "ddc8eea63f21915718f9fb22afefc484b5054919";
    sha256 = "16ri2qhdfz2dkm1bmcphydq0yriv5dm9f68r5rh8hy5m8bliq57c";
  };
}
