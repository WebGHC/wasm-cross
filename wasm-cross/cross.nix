{ lib
, localSystem, crossSystem, config, overlays
} @ args:

assert crossSystem.config == "wasm32-unknown-none-unknown";

let
  normalCrossStages = import "${(import ../nixpkgs {}).path}/pkgs/stdenv/cross" args;
  len = builtins.length normalCrossStages;
  bootStages = lib.lists.take (len - 2) normalCrossStages;
in bootStages ++ [
  (vanillaPackages: let
    llvmPackages = vanillaPackages.callPackage (import ../llvm-head) {};
    old = (builtins.elemAt normalCrossStages (len - 2)) vanillaPackages;
    my-binutils = with llvmPackages; vanillaPackages.runCommand "binutils" { nativeBuildInputs = [ llvm lld ]; } ''
      mkdir -p $out/bin
      ln -s ${lld}/bin/lld $out/bin/ld
      for prog in ${lld}/bin/* ${llvm}/bin/*; do # */
        ln -s $prog $out/bin/$(basename $prog)
      done
    '';
  in old // {
    stdenv = vanillaPackages.stdenv.override (oldStdenv: {
      allowedRequisites = null;
      overrides = self: super: oldStdenv.overrides self super // {
        my-llvmPackages = llvmPackages;
        binutils = my-binutils;
        my-clangCross = self.wrapCCCross {
          name = "clang-cross-wrapper";
          cc = llvmPackages.clang-unwrapped;
          binutils = my-binutils;
          libc = null;
        };
      };
    });
  })

  (toolPackages: let
    old = (builtins.elemAt normalCrossStages (len - 1)) toolPackages;
  in old // {
    stdenv = toolPackages.makeStdenvCross {
      stdenv = old.stdenv;
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = toolPackages.my-clangCross;
      overrides = self: super: {
        # TODO?
      };
    };
  })
]
