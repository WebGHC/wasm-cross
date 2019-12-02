{ debugLlvm ? false, haskellProfiling ? false, overlays ? [] }:

(import ./nixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      fib-example = self.callPackage ./fib-example {};

      hello-example = self.callPackage ./hello-example {};

      haskell-example = self.build-wasm-app { ename = "hello"; pkg = self.haskell.packages.ghcWasm.hello; };

      llvmPackages_HEAD = self.callPackage ./llvm-head {
        buildTools = self.buildPackages.llvmPackages_HEAD;
        debugVersion = debugLlvm;
      };

      wabt = self.callPackage ./wabt.nix {};
      binaryen = self.callPackage ./binaryen.nix {};

      webabi = self.callPackage ./webabi-nix {};

      webghc-runner = self.writeShellScriptBin "webghc-runner" ''
        exec ${self.nodejs-8_x}/bin/node ${self.webabi}/lib/node_modules/webabi/build/node_runner.js "$@"
      '';

      build-wasm-app = self.callPackage ./build-wasm-app.nix {};

      # Issue happens when combining pkgsStatic & custom cross stdenv.
      # We need to force a normal busybox here to avoid hitting a
      # weird bootstrapping issue.
      busybox-sandbox-shell = super.busybox-sandbox-shell.override { busybox = self.busybox; };
    })] ++ overlays;
    config = { allowUnsupportedSystem = true; };
  };
  nixpkgsCrossArgs = project.nixpkgsArgs // {
    stdenvStages = import ./cross.nix haskellProfiling;
  };

  nixpkgs = import ./nixpkgs project.nixpkgsArgs;
  nixpkgsWasm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = {
      config = "wasm32-unknown-unknown-wasm";
      arch = "wasm32";
      libc = null;
      disableDynamicLinker = true;
      thread-model = "single";
      # target-cpu = "bleeding-edge";
    };
  });
  nixpkgsArm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = (import "${(import ./nixpkgs {}).path}/lib/systems/examples.nix" { inherit (project.nixpkgs) lib; }).aarch64-multiplatform;
  });
  # nixpkgsRpi = import ./nixpkgs (project.nixpkgsCrossArgs // {
  #   crossSystem = (import "${(import ./nixpkgs {}).path}/lib/systems/examples.nix" { inherit (project.nixpkgs) lib; }).raspberryPi // { disableDynamicLinker = true; };
  # });
})
