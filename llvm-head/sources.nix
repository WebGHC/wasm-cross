{ fetchFromGitHub }: {
  clang = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang";
    rev = "4d48be1aa7744f3e4f5b0a53dad7fdde7885da41";
    sha256 = "0qxjr6vr2bz1xj2ig6wx9z0v2hp8giyg4xr90b1xy408q3lpqcjj";
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
    rev = "f8dd899c6c05e91652a92f7f7e0d61255142780f";
    sha256 = "1c1fcxjbqn2rlgg1wl0absms7n9d84w0mijkffdgbcy9sx90zr66";
  };
  libcxx = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libcxx";
    rev = "52cd8e497ad7fd1aa256c01a1cd989bf20242044";
    sha256 = "0z1vviy4f540bx0d087vxrhpdjmi876dz1nmd274hha8kmwgc79v";
  };
  lldb = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lldb";
    rev = "58bb4f62236100737e46a886cfd4c80f94084443";
    sha256 = "1p2z0i0yxwkfg0z7i04wlmq9280r7gniylsgng0rwmch70alnf9l";
  };
  clang-tools-extra = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "clang-tools-extra";
    rev = "05d033ed8a85c8862f2c67187d2dc5dfc554c91e";
    sha256 = "066slid90pfpv6697ydysrk50lm8pjr1rx84kfp0qzlkyj2kyqkh";
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
    rev = "aec8ba39dedba0ed7e6f0ae8f287c0f10c4c88f7";
    sha256 = "0v44j3ha5sh8fdz4g10ylcfz7cncwf1fmj636y9xpqk90miv7f44";
  };
  lld = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "lld";
    rev = "b6bd248aa7d17f1f98515d396b260f7e78580c9b";
    sha256 = "1zybly10fmxgrm34zvshflzq2ihsvh84kcqmp3in5v57q5vhjp6y";
  };
}
