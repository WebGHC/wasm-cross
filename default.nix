{ debugClang ? false }:

(import ./nixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      fib-example = self.callPackage ./fib-example {};

      llvmPackages_HEAD = self.callPackage ./llvm-head {
        buildTools = self.buildPackages.llvmPackages_HEAD;
        debugVersion = debugClang;
        enableSharedLibraries = !debugClang;
      };

      llvmPackages = self.llvmPackages_HEAD;

      binaryen = self.callPackage ./binaryen.nix {};

      # https://github.com/NixOS/nixpkgs/pull/27072
      swig = super.swig.overrideDerivation (drv: rec {
        name = "swig-${version}";
        version = "3.0.12";

        src = self.fetchFromGitHub {
          owner = "swig";
          repo = "swig";
          rev = "rel-${version}";
          sha256 = "1wyffskbkzj5zyhjnnpip80xzsjcr3p0q5486z3wdwabnysnhn8n";
        };
      });
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
    };
  });
  nixpkgsArm = import ./nixpkgs (project.nixpkgsCrossArgs // {
    crossSystem = (import "${(import ./nixpkgs {}).path}/lib/systems/examples.nix").aarch64-multiplatform;
  });
  nixpkgsNative = import ./nixpkgs (project.nixpkgsCrossArgs // {
    # crossSystem = project.nixpkgs.hostPlatform;
  });
})
