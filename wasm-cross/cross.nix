{ lib
, localSystem, crossSystem, config, overlays
}:

# assert crossSystem.config == "wasm32-unknown-none-unknown"; # "aarch64-unknown-linux-gnu"

let
  bootStages = import "${(import ../nixpkgs {}).path}/pkgs/stdenv" {
    inherit lib localSystem overlays;
    crossSystem = null;
    # Ignore custom stdenvs when cross compiling for compatability
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in bootStages ++ [

  # Build Packages
  (vanillaPackages: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    stdenv = vanillaPackages.stdenv.override (oldStdenv: {
      overrides = self: super: let
        mkClang = { ccFlags ? "", libc ? null, extraPackages ? [] }: self.wrapCCCross {
          name = "clang-cross-wrapper";
          cc = self.llvmPackages_HEAD.clang-unwrapped;
          inherit libc extraPackages binutils;
          extraBuildCommands = ''
            echo "-target ${crossSystem.config} -nostdinc -nostartfiles -nodefaultlibs ${ccFlags}" >> $out/nix-support/cc-cflags

            echo 'export CC=${crossSystem.config}-cc' >> $out/nix-support/setup-hook
            echo 'export CXX=${crossSystem.config}-c++' >> $out/nix-support/setup-hook
          '';
        };
        mkStdenv = cc: self.makeStdenvCross {
          inherit (self) stdenv;
          buildPlatform = localSystem;
          hostPlatform = crossSystem;
          targetPlatform = crossSystem;
          inherit cc;
        };

        binutils = with self.llvmPackages_HEAD; vanillaPackages.runCommand "binutils" { propogatedNativeBuildInputs = [ llvm lld ]; } ''
          mkdir -p $out/bin
          for prog in ${lld}/bin/*; do
            ln -s $prog $out/bin/${crossSystem.config}-$(basename $prog)
          done
          for prog in ${llvm}/bin/llvm-*; do
            ln -s $prog $out/bin/${crossSystem.config}-$(echo $(basename $prog) | sed -e "s|llvm-||")
          done

          ln -s ${llvm}/bin/llvm-ar $out/bin/ar
          ln -s ${llvm}/bin/llvm-ranlib $out/bin/ranlib
          ln -s ${lld}/bin/lld $out/bin/ld
          ln -s ${lld}/bin/lld $out/bin/${crossSystem.config}-ld
          ln -s ${lld}/bin/lld $out/bin/${crossSystem.config}-ld.gold
        ''; # TODO: Figure out the ld.gold thing for GHC

        clangCross-noLibc = mkClang {};
        clangCross-noCompilerRt = mkClang {
          ccFlags = "-lc";
          libc = musl-cross;
        };
        clangCross = mkClang {
          ccFlags = "-lc";
          libc = musl-cross;
          extraPackages = [ compiler-rt ];
        };

        stdenvNoLibc = mkStdenv clangCross-noLibc;
        stdenvNoCompilerRt = mkStdenv clangCross-noCompilerRt;

        musl-cross = self.__targetPackages.callPackage ../musl-cross {
          enableSharedLibraries = false;
          stdenv = stdenvNoLibc;
        };

        llvmPackages-cross = self.__targetPackages.llvmPackages_HEAD.override {
          stdenv = stdenvNoCompilerRt;
          enableSharedLibraries = false;
        };
        inherit (llvmPackages-cross) compiler-rt;
      in oldStdenv.overrides self super // { inherit clangCross musl-cross compiler-rt; };
    });
  })

  # Run Packages
  (toolPackages: {
    buildPlatform = localSystem;
    hostPlatform = crossSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    stdenv = toolPackages.makeStdenvCross {
      inherit (toolPackages) stdenv;
      overrides = self: super: {};
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = toolPackages.clangCross;
    };
  })

]
