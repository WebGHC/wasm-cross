{ lib
, localSystem, crossSystem, config, overlays
} @ args:

assert crossSystem.config == "wasm32-unknown-none-unknown";

let
  bootStages = import "${(import ../nixpkgs {}).path}/pkgs/stdenv" {
    inherit lib localSystem overlays;
    crossSystem = null;
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };
in bootStages ++ [
  (vanillaPackages: let llvmPackages = vanillaPackages.callPackage (import ../llvm-head) { cross = crossSystem; }; in {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    allowCustomOverrides = true;
    stdenv = vanillaPackages.stdenv.override (oldStdenv: {
      allowedRequisites = null;
      overrides = self: super: oldStdenv.overrides self super // {
        my-llvmPackages = llvmPackages;
      };
    });
  })

  (buildPackages: {
    buildPlatform = localSystem;
    hostPlatform = crossSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    stdenv = buildPackages.makeStdenvCross buildPackages.my-llvmPackages.stdenv crossSystem (buildPackages.wrapCCCross {
      name = "clang-cross-wrapper";
      cc = buildPackages.my-llvmPackages.clang-unwrapped; # TODO: Wrap this stuff with triple prefixing
      binutils =
        with buildPackages.my-llvmPackages; buildPackages.runCommand "binutils" { propagatedBuildInputs = [ llvm lld ]; } ''
	  mkdir -p $out/bin
	  ln -s ${lld}/bin/lld $out/bin/ld
	  for prog in ${lld}/bin/* ${llvm}/bin/*; do # */
	    ln -s $prog $out/bin/$(basename $prog)
	  done
	'';
      libc = ""; # TODO
    });
  })
]
