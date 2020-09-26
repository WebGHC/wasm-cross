{ nixpkgsFunc ? import ./nixpkgs
, haskellProfiling ? false
, overlays ? []
}:

let
  webghc = import ./webghc.nix { inherit ((nixpkgsFunc {}).buildPackages) fetchgit; };

in (nixpkgsFunc {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = overlays;
    # XXX This is required just to build some haskell packages with ghcjs. (ie to build release.nix completely)
    config = { allowBroken = true; };
  };

  nixpkgsCrossArgs = ghcSrc: ghcVersion: {
    stdenvStages = import ./cross.nix (nixpkgsFunc {})
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

  nixpkgs = nixpkgsFunc project.nixpkgsArgs;
  nixpkgsWasm = nixpkgsFunc (project.nixpkgsArgs //
    project.nixpkgsCrossArgs webghc.ghc881Src "8.8.1");
  nixpkgsWasm865 = nixpkgsFunc (project.nixpkgsArgs //
    project.nixpkgsCrossArgs webghc.ghc865Src "8.6.5");
})
