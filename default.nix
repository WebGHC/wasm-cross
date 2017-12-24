{ debugLlvm ? false }:

(import ./nixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      fib-example = self.callPackage ./fib-example {};

      hello-example = self.callPackage ./hello-example {};

      llvmPackages_HEAD = self.callPackage ./llvm-head {
        buildTools = self.buildPackages.llvmPackages_HEAD;
        debugVersion = debugLlvm;
      };

      llvmPackages = self.llvmPackages_HEAD;

      wabt = self.callPackage ./wabt.nix {};

      webabi = self.callPackage ./webabi-nix { webabi = {
        outPath = self.fetchFromGitHub {
          owner = "WebGHC";
          repo = "webabi";
          rev = "aba8197e30449b21447612f85cd5e5e08f5c8825";
          sha256 = "0m674kx6d09dqa5lwz29szzhsaxr1s1qhr8z6n6h69dnb6kbfcnv";
        };
        name = "webabi";
      }; };

      build-wasm-app = www: drv: self.buildEnv {
        name = "wasm-app-${drv.name}";
        paths = [
          www
          "${self.buildPackages.webabi.build}/lib/node_modules/webabi"
          "${drv}/bin"
        ];

        passthru = { inherit drv; };
      };
    })];
  };
  nixpkgsCrossArgs = project.nixpkgsArgs // {
    stdenvStages = import ./cross.nix;
  };

  nixpkgs = import ./nixpkgs project.nixpkgsArgs;
  nixpkgsWasm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = {
      config = "wasm32-unknown-unknown-wasm";
      arch = "wasm32";
      libc = null;
      disableDynamicLinker = true;
      thread-model = "single";
      entry = "main";
      # target-cpu = "bleeding-edge";
    };
  });
  nixpkgsArm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = (import "${(import ./nixpkgs {}).path}/lib/systems/examples.nix" { inherit (project.nixpkgs) lib; }).aarch64-multiplatform;
  });
  nixpkgsRpi = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = (import "${(import ./nixpkgs {}).path}/lib/systems/examples.nix" { inherit (project.nixpkgs) lib; }).raspberryPi // { disableDynamicLinker = true; };
  });
})
