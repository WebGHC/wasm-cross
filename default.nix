{ baseNixpkgs ? import ./nixpkgs
, debugLlvm ? false
, haskellProfiling ? false
, overlays ? []
}:

(baseNixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      fib-example = self.callPackage ./fib-example {};

      hello-example = self.callPackage ./hello-example {};

      haskell-example = self.build-wasm-app { ename = "hello"; pkg = self.haskell.packages.ghcWasm.hello; };

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
