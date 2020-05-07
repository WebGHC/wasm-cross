{ fetchgit }:
{
  ghc881Src = fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "daebc38ffb78c21904eb3b508790f43291fe2e87";
    sha256 = "1dwlxpna0bp0gnj0lrzwcdpzjvcyg1j55r1dajpxpxhf71i74iqg";
    fetchSubmodules = true;
  };

  ghc865Src = fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "9f0543186dc8a423d5dbe48502b19282816e024f";
    sha256 = "0qpvaaccqd14dpq66b16vmaakily0chyk87hcalh63iym02qdspw";
    fetchSubmodules = true;
  };

  ghc865SplicesSrc = fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "1d4026e91ec844ccbe23dacc26a399e250b8fd11";
    sha256 = "061rnv15yqg83y8cx85294jl29bmvd2cb9h7zfz4bihr79m0ln0n";
    fetchSubmodules = true;
  };
}
