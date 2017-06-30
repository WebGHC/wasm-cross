{ ... } @ args: import ../nixpkgs (args // {
  # crossSystem = {
  #   config = "wasm32-unknown-none-wasm";
  #   arch = "wasm32";
  #   libc = null;
  # };
  crossSystem = (import "${(import ../nixpkgs {}).path}/lib/systems/examples.nix").aarch64-multiplatform;
  stdenvStages = import ./cross.nix;
})
