{ ... } @ args: import ../nixpkgs (args // {
  # crossSystem = {
  #   config = "wasm32-unknown-none-unknown";
  #   arch = "wasm32";
  #   libc = null;
  #   openssl.system = "linux-generic64";
  # };
  crossSystem = (import "${(import ../nixpkgs {}).path}/lib/systems/examples.nix").aarch64-multiplatform;
  stdenvStages = import ./cross.nix;
})
