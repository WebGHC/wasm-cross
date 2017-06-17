{ ... } @ args: import ../nixpkgs (args // {
  crossSystem = {
    config = "wasm32-unknown-none-unknown";
    arch = "wasm32";
    libc = null;
    openssl.system = "linux-generic64";
  };
  stdenvStages = import ./cross.nix;
})
