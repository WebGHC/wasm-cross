{ fetchgit }:
{
  ghc881Src = fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "b631c4d47c8813816e3a6531cc76ef45ab279da8";
    sha256 = "13jf1l3lcia6kgy9zbwvl2vrh7r3i97zv13a54pz5kpfr930s5dr";
    fetchSubmodules = true;
    preFetch = ''
      export HOME=$(pwd)
      git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
    '';
  };

  ghc865Src = fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "c34a766da0858960cf810eaac779052347d6e9f4";
    sha256 = "1ignbbfaxli1waa1bhvs61nzgcyl0mljy3q4cg31zpcdja31c8kg";
    fetchSubmodules = true;
    preFetch = ''
      export HOME=$(pwd)
      git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
    '';
  };

  ghc865SplicesSrc = fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "746a6e61c69f57ba6441a922bd7b6fe807b2dd2f";
    sha256 = "0ghza2ix9lp5di7mgqzahlbxm9i0w4l10nxi99ls2n6xm2g231j3";
    fetchSubmodules = true;
    # No preFetch needed here as the submodule URIs have been made absolute
  };
}
