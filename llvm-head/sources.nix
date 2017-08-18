{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "7db24143e836a8d389bffec055f32df55a6c081c";
    sha256 = "1z1jzk2kbiy5s7flkihpsx6jrfaq0hq2r9m53x1r072yfz5w7v4l";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "b157fdd968a4e1093645ec7c65213736c4bc7ea6";
    sha256 = "1jqjgkfsfqjf6j4laqn88qjm7dmnfw50xwdp7y4qgrvhlzynz66g";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "cb8d6dea184609512650a6c599ef851518027954";
    sha256 = "1qkqyqh7gprb54phav9ap46aw78qjqxjb1j4vlmi2san5mw9gqgv";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "b859a78a6f02bc29e9ccb749adc79f842a18e2e8";
    sha256 = "1nabj6qd95iyxszrxql1g4j8f5qyy1hrv8lawz5m1wcqpc7v8ziz";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "ec3c23cb370a881bf2074d4eee85e03f88f2d149";
    sha256 = "1jrjz2y1zikqrs8gx90bbcj2hml1rl8nw1qm16bsrxkqz69h9fp9";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "2f301f50187ede4b9b8c7456ac4a67b9f7418004";
    sha256 = "03zad73mz13cv4c4iabax3p4bg7n5izm6zwwvmpw1rqjbd1ifr5w";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "4f4c5d0784c1c23c85baa3ffe301f7256a5217bc";
    sha256 = "16k842nrin0187bpkmwl2ma01c2qz8zs1rlyarirzbkly091bw6v";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "4a6d122a262547d4c6978bc6c87a9d417109fe61";
    sha256 = "0qbwgi5mgbhcqzzwfarhhgfgdrhk7hsk0n9izin697r295fhsk4a";
  };
  lld = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "lld";
    rev = "196bcc693535ab48f9e0fd95bd10b712f3431b61";
    sha256 = "02ipvmw5v51ggm0ypwq8zmd5xxw7z4s0dq25d5hjjph42rhgrwzp";
  };
}
