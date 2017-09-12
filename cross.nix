{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem != null;

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
        prefix = "${crossSystem.config}-";
        llvmPackages = self.llvmPackages_HEAD;
        mkClang = { ldFlags ? null, libc ? null, extraPackages ? [], ccFlags ? null }: self.wrapCCCross {
          name = "clang-cross-wrapper";
          cc = llvmPackages.clang-unwrapped;
          binutils = llvmPackages.llvm-binutils;
          inherit libc extraPackages;
          extraBuildCommands = ''
            # We don't yet support C++
            # https://github.com/WebGHC/wasm-cross/issues/1
            echo "-target ${crossSystem.config} -nostdlib++" >> $out/nix-support/cc-cflags
            # Clang's wasm backend assumes the presence of a working
            # lld (optionally with prefix). We symlink it here to get
            # a wrapper version.
            ln -s $out/bin/${prefix}ld $out/bin/${prefix}lld

            # Something about the way clang is handled on macOS makes
            # this necessary even on Linux.
            echo 'export CC=${prefix}cc' >> $out/nix-support/setup-hook
            echo 'export CXX=${prefix}c++' >> $out/nix-support/setup-hook
          '' + self.lib.optionalString (ccFlags != null) ''
            echo "${ccFlags}" >> $out/nix-support/cc-cflags
          '' + self.lib.optionalString (ldFlags != null) ''
            echo "${ldFlags}" >> $out/nix-support/cc-ldflags
          '' + self.lib.optionalString (crossSystem.arch == "wasm32") ''
            echo "--allow-undefined -entry=main" >> $out/nix-support/cc-ldflags
          '';
        };

        mkStdenv = cc:
          let
            overrides = self: super: {
              ncurses = (super.ncurses.override { androidMinimal = true; }).overrideDerivation (drv: {
                patches = drv.patches or [] ++ [./ncurses.patch];
                configureFlags = drv.configureFlags or []
                  ++ self.lib.optionals (crossSystem.arch == "wasm32") ["--without-progs" "--without-tests"];
              });
              haskellPackages = self.haskell.packages.ghcHEAD;
              haskell = let inherit (super) haskell; in haskell // {
                packages = haskell.packages // {
                  ghcHEAD = haskell.packages.ghcHEAD.override (drv: {
                    ghc = drv.ghc.override {
                      dynamic = false;
                      enableRelocatedStaticLibs = false;
                      enableIntegerSimple = true;
                      # quick-cross = true; # Just for dev
                    };
                    overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (self: super: {
                      mkDerivation = args: super.mkDerivation (args // {
                        enableExecutableStripping = false;
                        enableLibraryStripping = false;
                        enableSharedExecutables = false;
                        enableSharedLibraries = false;
                      });
                    });
                  });
                };
              };
            };
            x = self.makeStdenvCross {
              inherit (self) stdenv;
              buildPlatform = localSystem;
              hostPlatform = crossSystem;
              targetPlatform = crossSystem;
              inherit cc overrides;
            };
          in x // {
            mkDerivation = args: x.mkDerivation (args // {
              hardeningDisable = args.hardeningDisable or []
                ++ ["stackprotector"]
                ++ self.lib.optional (crossSystem.arch == "wasm32") "pic";
              dontDisableStatic = true;
              configureFlags =
                (let flags = args.configureFlags or [];
                  in if builtins.isString flags then [flags] else flags)
                ++ self.lib.optionals (!(args.dontConfigureStatic or false)) ["--enable-static" "--disable-shared"];
            });
            isStatic = true;
          };

        clangCross-noLibc = mkClang {
          ccFlags = "-nostdinc -nodefaultlibs";
        };
        clangCross-noCompilerRt = mkClang {
          libc = musl-cross;
          ccFlags = "-nodefaultlibs";
          ldFlags = "-lc";
        };
        clangCross = mkClang {
          # TODO: Just use -rtlib=...  This is hard because Clang
          # currently expects compiler-rt builtins to be a crazy place
          ccFlags = "-L${compiler-rt}/lib ${self.lib.optionalString (crossSystem.arch != "wasm32") "-lcompiler_rt"}";
          libc = musl-cross;
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
    hostPlatform = crossSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    stdenv = toolPackages.llvmStdenvCross;
  })

]
