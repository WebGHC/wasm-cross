{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem.config == "wasm32-unknown-none-unknown";

let
  bootStages = import "${(import ../nixpkgs {}).path}/pkgs/stdenv" {
    inherit lib localSystem overlays;
    crossSystem = null;
    # Ignore custom stdenvs when cross compiling for compatability
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in bootStages ++ [

  # Build Packages
  (vanillaPackages: let
    llvmPackages = vanillaPackages.callPackage (import ../llvm-head) {};
    my-binutils = with llvmPackages; vanillaPackages.runCommand "binutils" { nativeBuildInputs = [ llvm lld ]; } ''
      mkdir -p $out/bin
      ln -s ${lld}/bin/lld $out/bin/ld
      for prog in ${lld}/bin/* ${llvm}/bin/*; do # */
        ln -s $prog $out/bin/$(basename $prog)
      done
    '';
  in {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    stdenv = vanillaPackages.stdenv.override (oldStdenv: {
      overrides = self: super: oldStdenv.overrides self super // {
        my-llvmPackages = llvmPackages;
        my-clangCross-noLibc = self.wrapCCCross {
          name = "clang-cross-wrapper";
          cc = llvmPackages.clang-unwrapped;
          binutils = my-binutils;
          libc = null;
          noLibc = true;
          extraBuildCommands = ''
            echo "-target ${crossSystem.config}" >> $out/nix-support/cc-cflags

            echo 'export CC=${crossSystem.config}-cc' >> $out/nix-support/setup-hook
            echo 'export CXX=${crossSystem.config}-c++' >> $out/nix-support/setup-hook
          '';
        };
        my-clangCross = self.wrapCCCross {
          name = "clang-cross-wrapper";
          cc = llvmPackages.clang-unwrapped;
          binutils = my-binutils;
          libc = abort "No libc yet";
          extraBuildCommands = ''
            echo "-target ${crossSystem.config}" >> $out/nix-support/cc-cflags

            echo 'export CC=${crossSystem.config}-cc' >> $out/nix-support/setup-hook
            echo 'export CXX=${crossSystem.config}-c++' >> $out/nix-support/setup-hook
          '';
        };
      };
    });
  })

  # Run Packages
  (toolPackages: let
    stdenvNoLibc = toolPackages.makeStdenvCross {
      stdenv = toolPackages.stdenv;
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = toolPackages.my-clangCross-noLibc;
    };
  in {
    buildPlatform = localSystem;
    hostPlatform = crossSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    stdenv = toolPackages.makeStdenvCross {
      inherit (toolPackages) stdenv;
      overrides = self: super: {
        compiler-rt = stdenvNoLibc.mkDerivation {
          name = "compiler-rt";
          src = toolPackages.my-llvmPackages.compiler-rt_src;
          nativeBuildInputs = [ toolPackages.cmake ];
          cmakeFlags = [
            "-DLLVM_CONFIG_PATH=${toolPackages.my-llvmPackages.llvm}/bin/llvm-config"
            "-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=${crossSystem.config}"
            "-DCMAKE_C_COMPILER_WORKS=1"
            "-DCMAKE_CXX_COMPILER_WORKS=1"
            "--target" "../lib/builtins"
            "-DCMAKE_SYSTEM_NAME=Generic"
          ];
        };
      };
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = toolPackages.my-clangCross;
    };
  })

]
