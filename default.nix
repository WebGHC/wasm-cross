(import ./nixpkgs {}).lib.makeExtensible (project: {
  nixpkgsArgs = {
    overlays = [(self: super: {
      fib-example = self.callPackage ./fib-example {};

      llvmPackages_HEAD = self.callPackage ./llvm-head { buildTools = self.buildPackages.llvmPackages_HEAD; };

      llvmPackages = self.llvmPackages_HEAD;

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
