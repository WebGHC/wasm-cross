(import ./nixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      cmake-hello-world = self.callPackage ./cmake-hello-world {};

      fib-example = self.callPackage ./fib-example {};

      llvmPackages_HEAD = self.callPackage ./llvm-head { buildTools = self.buildPackages.llvmPackages_HEAD; };

      llvmPackages = self.llvmPackages_HEAD;
    })];
  };
  nixpkgsCrossArgs = project.nixpkgsArgs // {};

  nixpkgs = import ./nixpkgs project.nixpkgsArgs;
  nixpkgsWasm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = {
      config = "wasm32-unknown-none-wasm";
      arch = "wasm32";
      libc = null;
    };
    stdenvStages = import ./cross.nix;
  });
  nixpkgsArm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = (import "${(import ./nixpkgs {}).path}/lib/systems/examples.nix").aarch64-multiplatform;
    stdenvStages = import ./cross.nix;
  });
})
