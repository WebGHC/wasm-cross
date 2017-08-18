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
        mkClang = { ldFlags ? null, libc ? null, extraPackages ? [] }: self.wrapCCCross {
          name = "clang-cross-wrapper";
          cc = self.llvmPackages_HEAD.clang-unwrapped;
          binutils = self.llvmPackages_HEAD.llvm-binutils;
          inherit libc extraPackages;
          extraBuildCommands = ''
            echo "-target ${crossSystem.config} -nostdinc -nodefaultlibs -nostartfiles" >> $out/nix-support/cc-cflags
            # TODO: Build start files so entry isn't main
            echo "-entry=main" >> $out/nix-support/cc-ldflags

            echo 'export CC=${crossSystem.config}-cc' >> $out/nix-support/setup-hook
            echo 'export CXX=${crossSystem.config}-c++' >> $out/nix-support/setup-hook
          '' + (self.lib.optionalString (libc != null) ''
            echo "-lc" >> $out/nix-support/libc-ldflags
          '') + (self.lib.optionalString (ldFlags != null) ''
            echo "${ldFlags}" >> $out/nix-support/cc-ldflags
          '') + (self.lib.optionalString (crossSystem.arch == "wasm32") ''
            echo "--allow-undefined" >> $out/nix-support/cc-ldflags
          '');
        };
        mkStdenv = cc: let x = (self.makeStdenvCross {
          inherit (self) stdenv;
          buildPlatform = localSystem;
          hostPlatform = crossSystem;
          targetPlatform = crossSystem;
          inherit cc;
        });
        in x //  {
          mkDerivation = args: x.mkDerivation (args // {
            hardeningDisable = args.hardeningDisable or [] ++ ["all"];
            dontDisableStatic = true;
            configureFlags = args.configureFlags or [] ++ ["--enable-static" "--disable-shared"];
          });
          isStatic = true;
        };

        clangCross-noLibc = mkClang {};
        clangCross-noCompilerRt = mkClang {
          libc = musl-cross;
        };
        clangCross = mkClang {
          # TODO: Should not have to add compiler-rt to the library path. Should be handled by extraPackages.
          ldFlags = "-L${compiler-rt}/lib -lcompiler_rt";
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
      in oldStdenv.overrides self super // {
        inherit clangCross musl-cross compiler-rt;
        binutils = self.llvmPackages_HEAD.llvm-binutils;
      };
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
      overrides = self: super: {
        ncurses = (super.ncurses.override { androidMinimal = true; }).overrideDerivation (drv: {
          patches = drv.patches or [] ++ [./ncurses.patch];
          configureFlags = drv.configureFlags or [] ++ ["--without-progs" "--without-tests"];
        });
      };
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = toolPackages.clangCross;
    };
  })

]
