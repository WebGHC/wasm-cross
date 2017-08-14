{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "7602b13a8e8b5656afd6327d112b76b39f836e5b";
    sha256 = "12m0mvbpi5abnd76alx6m0dis0558skjnykfci20fq9fc4ssib19";
  };
  libcxxabi = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxxabi";
    rev = "7de232a3f6f6b6d5f2892b689095fb13d732bbcb";
    sha256 = "1jqjgkfsfqjf6j4laqn88qjm7dmnfw50xwdp7y4qgrvhlzynz66g";
  };
  llvm = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "llvm";
    rev = "ec9eb8644dce597eba339778b5db74dd54181a42";
    sha256 = "12jb0p6mi7prz8s9108b9sfjyxd5cspk3fvcjdq4z67rjxr5h94b";
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
    rev = "92f8a27dbf9c9c64558f7b22cd298c31288266a3";
    sha256 = "04kg4ymiaij7j4wqs8drnnbqqg1xppsbmhr3nz196sl4layppxv7";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "4d2e5ec3c7eb64b1b1f941b761cd702e01c3783f";
    sha256 = "0x4zamgm1fhjy1vfdip1whncg8r3z2b5sw38jb2f3dagl0wmf9kp";
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
    rev = "83dafd31d45ad9648dfde40206ebc33cd71af735";
    sha256 = "094l95hakc012bcqpknhmwhkmi06l1wafpzmsj3qmkkbjk3gpgyz";
  };
  lld = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "lld";
    rev = "b66cb81fe15c7ad8767a21a1e7830ee839776aff";
    sha256 = "06hjh09v5zj9bv6mr9548may6zz0kvg0ck7n92jpwifwvmigy1pd";
  };
}
