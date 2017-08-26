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
  targetSystem = if crossSystem == null then localSystem else crossSystem;

in bootStages ++ [

  # Build Packages
  (vanillaPackages: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = targetSystem;
    inherit config overlays;
    selfBuild = false;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    stdenv = vanillaPackages.stdenv.override (oldStdenv: {
      overrides = self: super: let
        llvmPackages = self.llvmPackages_HEAD;
        mkClang = { ldFlags ? null, libc ? null, extraPackages ? [], ccFlags ? null }:
          let
            extraBuildCommands = ''
              echo "-target ${targetSystem.config} -nostdinc -nodefaultlibs" >> $out/nix-support/cc-cflags
            '' + (self.lib.optionalString (libc != null) ''
              echo "-lc" >> $out/nix-support/libc-ldflags
            '') + (self.lib.optionalString (ccFlags != null) ''
              echo "${ccFlags}" >> $out/nix-support/cc-cflags
            '') + (self.lib.optionalString (ldFlags != null) ''
              echo "${ldFlags}" >> $out/nix-support/cc-ldflags
            '');
          in if localSystem != targetSystem
          then self.wrapCCCross {
            name = "clang-cross-wrapper";
            cc = llvmPackages.clang-unwrapped;
            binutils = llvmPackages.llvm-binutils;
            inherit libc extraPackages;
            extraBuildCommands = extraBuildCommands + ''
              echo 'export CC=${targetSystem.config}-cc' >> $out/nix-support/setup-hook
              echo 'export CXX=${targetSystem.config}-c++' >> $out/nix-support/setup-hook
            '' + (self.lib.optionalString (targetSystem.arch or null == "wasm32") ''
              echo "-nostartfiles" >> $out/nix-support/cc-cflags
              echo "--allow-undefined -entry=main" >> $out/nix-support/cc-ldflags
            '');
          }
          else self.ccWrapperFun {
            nativeTools = false;
            nativeLibc = false;
            nativePrefix = "";
            noLibc = libc == null;
            cc = llvmPackages.clang-unwrapped;
            isGNU = false;
            isClang = true;
            inherit libc extraPackages extraBuildCommands;
            binutils = llvmPackages.llvm-binutils;
          };

        mkStdenv = cc: let x = if localSystem != targetSystem
        then (self.makeStdenvCross {
          inherit (self) stdenv;
          buildPlatform = localSystem;
          hostPlatform = targetSystem;
          targetPlatform = targetSystem;
          overrides = self: super: {
            ncurses = (super.ncurses.override { androidMinimal = true; }).overrideDerivation (drv: {
              patches = drv.patches or [] ++ [./ncurses.patch];
              configureFlags = drv.configureFlags or [] ++ ["--without-progs" "--without-tests"];
            });
          };
          inherit cc;
        })
        else self.stdenv.override {
          inherit cc;
          overrides = _: _: {};
          allowedRequisites = null;
        };
        in x // {
          mkDerivation = args: x.mkDerivation (args // {
            hardeningDisable = args.hardeningDisable or []
                             ++ ["stackprotector"]
                             ++ self.lib.optional (targetSystem.arch or null == "wasm32") "pic";
            dontDisableStatic = true;
            configureFlags = let
              flags = args.configureFlags or [];
            in
              (if builtins.isString flags then [flags] else flags) ++ ["--enable-static" "--disable-shared"];
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
          stdenv = stdenvNoLibc;
        };

        llvmPackages-cross = self.__targetPackages.llvmPackages_HEAD.override {
          stdenv = stdenvNoCompilerRt;
          enableSharedLibraries = false;
        };
        compiler-rt = llvmPackages-cross.compiler-rt.override { baremetal = true; };
      in oldStdenv.overrides self super // {
        inherit clangCross musl-cross compiler-rt;
        binutils = llvmPackages.llvm-binutils;
        llvmStdenvCross = mkStdenv clangCross;
      };
    });
  })

  # Run Packages
  (toolPackages: {
    buildPlatform = localSystem;
    hostPlatform = targetSystem;
    targetPlatform = targetSystem;
    inherit config overlays;
    selfBuild = false;
    stdenv = toolPackages.llvmStdenvCross;
  })

]
