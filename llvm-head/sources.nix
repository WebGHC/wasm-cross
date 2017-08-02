{ fetch-llvm-mirror }: {
  llvm = fetch-llvm-mirror {
    name = "llvm";
    rev = "6e8db40d6507e45266435f69b304808aa7e31ea0";
    sha256 = "0f0aizzcvqhgw3sf5x3ln0mjyrky79rya8p7125hi7488q9viiw3";
  };
  clang = fetch-llvm-mirror {
    name = "clang";
    rev = "af1df2901bedeb6092c08745d00bfdb0e3a247af";
    sha256 = "1cxiz1bqbnc9xgm2qshavqqps1g8p7xyawj5dsiy1wc2d0fhdlb6";
  };
  lld = fetch-llvm-mirror {
    name = "lld";
    rev = "2a5edfd318c5bb8d5a691e4c1903a8793274afec";
    sha256 = "1wynvmfyh9dr1nvxzaqwsi7hmyr05x6cwvwrj486v7g28hrswsck";
  };
  clang-tools-extra = fetch-llvm-mirror {
    name = "clang-tools-extra";
    rev = "87ee00199a004cd81c09133c6899a0a75f874816";
    sha256 = "0jnlkqhjk8d62idkihwkw1bnzlllq1fk25mw0d97c85vd23ni75m";
  };
  compiler-rt = fetch-llvm-mirror {
    name = "compiler-rt";
    rev = "73ea55e16c3724f1ea0caa30a34aad7427dd36f7";
    sha256 = "0wj0m7jmkycarmxw50gz26qriic2v7j6knwajfgspq02wjarx9il";
  };
  libcxx = fetch-llvm-mirror {
    name = "libcxx";
    rev = "4876a73b0a667032d66cee0e8e4d4a5d4083bf3b";
    sha256 = "13vwdcah2ymdfbh428xdakhgxqvjkavnd5qzr1d7j4b2asiypjc6";
  };
  libcxxabi = fetch-llvm-mirror {
    name = "libcxxabi";
    rev = "b90082274531c38eb75bb5d30aac876d338004ea";
    sha256 = "1731qw9s7plam7k94n0s2lfkvf9l58q7zczyiss9jlkfdl71z03y";
  };
  libunwind = fetch-llvm-mirror {
    name = "libunwind";
    rev = "36c1a03b74e1eddbbc844b08dcf74c94556613ea";
    sha256 = "1lanhm49f1ybvbcq8va5f2zycm0abkwzp0ynlpsgxym26v24a14b";
  };
  lldb = fetch-llvm-mirror {
    name = "lldb";
    rev = "a47a6a9e9335f4a3204ac64cd7160763dd5bea4c";
    sha256 = "18xz28c6vya7h8m0ss1x42z9vj7zs8isp1g82lj71glrzcal4wa1";
  };
}
