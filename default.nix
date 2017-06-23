(import ./nixpkgs {}).lib.makeExtensible (wasm-cross-self: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      cmake-hello-world = self.callPackage ./cmake-hello-world {};

      llvmPackages_HEAD = self.callPackage ./llvm-head { buildTools = self.buildPackages.llvmPackages_HEAD; };
    })];
  };
  nixpkgsWasmArgs = wasm-cross-self.nixpkgsArgs // {};
  nixpkgs = import ./nixpkgs wasm-cross-self.nixpkgsArgs;
  nixpkgsWasm = import ./wasm-cross wasm-cross-self.nixpkgsWasmArgs;
})
