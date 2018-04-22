{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "67f6e8a2d2dd18a27940560167135c468570e67c";
    sha256 = "0n4xbycczb1n8ysjrd88b0wpyw6ih29kgghmsaq2r1vmzygidlwc";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "b95ff2df2d0b0f909f5f5fbe0731c960b64bdad4";
    sha256 = "0bsny1rdnn1zbqyapnya06wpwa6qdy3scfhnxawsizjhr6pp7vd9";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "3070e9a666a0118ce293fde5b9500dcf7ad1f0c9";
    sha256 = "158v4jpbr828bs09v23rjscbg9qy1nibxm4mjfgcmfc8wc8v8d18";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "efb6d58bf987fc9a35c06e4159c53630182a20d7";
    sha256 = "0caz6xhmavk7w3s8j46ld9x2rk6jrkg7pmgrvlqhvxrqhwir4kn6";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "2daa7575615ea567ed4eed549a4bae609a73a2ba";
    sha256 = "173m4icjm4js74gcrdckcii8nknr3g86p1k6pr6ps1q80xz459pn";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "0ef9865f89f40fa57ec8588b1b04561cd2de6689";
    sha256 = "0n96xfrymqlv8mz0y3aqw4m38zdrnc9pwiyhqyh5nsvg0dxwzk4k";
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
    rev = "9c5b02f71143a0beb3276dcc4f4e1e9e5f9531dd";
    sha256 = "1c00lypxqx04h6hm1g2q24pfpf5svs5528mf1n2c0iyx5krlhkas";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "9d681ac48b414fd60021442be265ae2b3bd052c9";
    sha256 = "0gc60im1vypgynimja4j72aa39jk64xgrb1zmkw3y7q63p0r8yj8";
  };
}
