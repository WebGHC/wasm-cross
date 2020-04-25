{ baseNixpkgs ? import ./nixpkgs
, haskellProfiling ? false
, overlays ? []
}:

let
  ghc881Version = "8.8.1";
  ghc881Src = (baseNixpkgs {}).buildPackages.fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "b631c4d47c8813816e3a6531cc76ef45ab279da8";
    sha256 = "13jf1l3lcia6kgy9zbwvl2vrh7r3i97zv13a54pz5kpfr930s5dr";
    fetchSubmodules = true;
    preFetch = ''
      export HOME=$(pwd)
      git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
    '';
  };

  ghc865Version = "8.6.5";
  ghc865Src = (baseNixpkgs {}).buildPackages.fetchgit {
    url = "https://github.com/WebGHC/ghc.git";
    rev = "c34a766da0858960cf810eaac779052347d6e9f4";
    sha256 = "1ignbbfaxli1waa1bhvs61nzgcyl0mljy3q4cg31zpcdja31c8kg";
    fetchSubmodules = true;
    preFetch = ''
      export HOME=$(pwd)
      git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
    '';
  };

in (baseNixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = overlays;
    config = { allowBroken = true; };
  };

  nixpkgsCrossArgs = ghcSrc: ghcVersion: {
    stdenvStages = import ./cross.nix (baseNixpkgs {})
      [ (import ./cross-overlays-libiconv.nix)
        (import ./cross-overlays-haskell.nix ghcSrc ghcVersion haskellProfiling)
      ];
    crossSystem = {
      config = "wasm32-unknown-unknown-wasm";
      arch = "wasm32";
      libc = null;
      useLLVM = true;
      disableDynamicLinker = true;
      thread-model = "single";
      # target-cpu = "bleeding-edge";
    };
  };

  nixpkgs = baseNixpkgs project.nixpkgsArgs;
  nixpkgsWasm = baseNixpkgs (project.nixpkgsArgs //
    project.nixpkgsCrossArgs ghc881Src ghc881Version);
  nixpkgsWasm865 = baseNixpkgs (project.nixpkgsArgs //
    project.nixpkgsCrossArgs ghc865Src ghc865Version);
})
