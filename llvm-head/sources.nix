{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "3084e0523123d62965567245dbbde3527a307a66";
    sha256 = "01f87dzg6d9ky8calj886k2xzijafkqsz9lq63mpb4lw5cj0m704";
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
    rev = "2368d9f73de09cd5ff2ac44b70cbd9128893c036";
    sha256 = "0j2058i39arz788zmnzjv5hc220dr72scjpgb0zz009m64y0clzw";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "e8c8bc94334771877d0ec962da5fb9d5b35cd85b";
    sha256 = "1qkmjmggqlw58kr8h72rc9bhw3fmxa51sfrikdjzkp0xszmr1bkg";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "91e77b77aa6f28ea8d66bf7ec0e36bf28125eeb2";
    sha256 = "1v74vknf97gz6jx69nrx18ln44gcm2s270dwjmc67kb5p864pnz2";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "c543235c134fbb02fb630eaa53661b188068b267";
    sha256 = "1pcgaxvirrrlin6h10xplpmnbi6jq0gzkbhxgz2wijw1y67f0n93";
  };
  libunwind = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libunwind";
    rev = "863d60e293b57fc41089cf3ff63a8cf174c30c65";
    sha256 = "0cav2zb1j56i3lvld1l9gv022djpirhj75hnx2cnai0bc2jscxqa";
  };
  compiler-rt = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "compiler-rt";
    rev = "422f200cdfd54bee317d925981b24b177bd46297";
    sha256 = "0ixn73isd9q6y36lcb8drw8704jr5mvqvwlmd9njfp6yzrnnrr7l";
  };
  lld = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "lld";
    rev = "e60a10d19b1e351374bfe276e54e1c5ea35fae52";
    sha256 = "13fi7dz7j8b6fxhz0x1m3wac49q42vq63i18zxdbb1qxpfm2qv0j";
  };
}
