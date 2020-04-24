{ baseNixpkgs ? import ./nixpkgs
, debugLlvm ? false
, haskellProfiling ? false
, overlays ? []
}:

(baseNixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = overlays;
    config = { allowBroken = true; };
  };

  nixpkgsCrossArgs = project.nixpkgsArgs // {
    stdenvStages = import ./cross.nix project.nixpkgs
      [ (import ./cross-overlays-libiconv.nix)
        (import ./cross-overlays-haskell.nix haskellProfiling)
      ];
  };

  nixpkgs = baseNixpkgs project.nixpkgsArgs;
  nixpkgsWasm = baseNixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = {
      config = "wasm32-unknown-unknown-wasm";
      arch = "wasm32";
      libc = null;
      useLLVM = true;
      disableDynamicLinker = true;
      thread-model = "single";
      # target-cpu = "bleeding-edge";
    };
  });
})
