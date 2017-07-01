{ lib
, localSystem, crossSystem, config, overlays
}:

# assert crossSystem.config == "wasm32-unknown-none-unknown"; # "aarch64-unknown-linux-gnu"

let
  bootStages = import "${(import ./nixpkgs {}).path}/pkgs/stdenv" {
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
          binutils = self.llvmPackages_HEAD.llvm-binutils;
          inherit libc extraPackages;
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

        clangCross-noLibc = mkClang {};
        clangCross-noCompilerRt = mkClang {
          ccFlags = "-lc";
          libc = musl-cross;
        };
        clangCross = mkClang {
          # TODO: Should not have to add compiler-rt to the library path. Should be handled by extraPackages.
          ccFlags = "-L${compiler-rt}/lib -lc -lcompiler_rt";
          libc = musl-cross;
          extraPackages = [ compiler-rt ];
        };

        stdenvNoLibc = mkStdenv clangCross-noLibc;
        stdenvNoCompilerRt = mkStdenv clangCross-noCompilerRt;

        musl-cross = self.__targetPackages.callPackage ./musl-cross.nix {
          enableSharedLibraries = false;
          stdenv = stdenvNoLibc;
        };

        llvmPackages-cross = self.__targetPackages.llvmPackages_HEAD.override {
          stdenv = stdenvNoCompilerRt;
          enableSharedLibraries = false;
        };
        compiler-rt = llvmPackages-cross.compiler-rt.override { baremetal = true; };
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
