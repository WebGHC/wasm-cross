{ lib
, localSystem, crossSystem, config, overlays
}:

self: super: {
  libiconvReal =
    if crossSystem.isWasm
    then super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];})
    else super.libiconvReal;
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something

  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcHEAD = haskell.packages.ghcHEAD.override (drv: {
        ghc = (drv.ghc.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          withTerminfo = false;
          dontStrip = true;
          dontUseLibFFIForAdjustors = crossSystem.isWasm;
          disableFFI = crossSystem.isWasm;
          useLLVM = true;
          version = "8.5.20180424";
          buildLlvmPackages = self.buildPackages.llvmPackages_HEAD;
          llvmPackages = self.buildPackages.llvmPackages_HEAD;
        }).overrideAttrs (drv: {
          src =
            if !(crossSystem.isWasm)
              then drv.src
              else self.buildPackages.fetchgit {
                url = "https://github.com/WebGHC/ghc.git";
                rev = "895006cb628bd1a2434749d7f056c901f9c76af1";
                sha256 = "1yaganq5rpvfnf75pn0g1ir3693j893agdpmmcpbcbv77z6rsadp";
                preFetch = ''
                  export HOME=$(pwd)
                  git config --global url."git://github.com/WebGHC/packages-".insteadOf     git://github.com/WebGHC/packages/
                  git config --global url."http://github.com/WebGHC/packages-".insteadOf    http://github.com/WebGHC/packages/
                  git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
                  git config --global url."ssh://git@github.com/WebGHC/packages-".insteadOf ssh://git@github.com/WebGHC/packages/
                  git config --global url."git@github.com:WebGHC/packages-".insteadOf       git@github.com:WebGHC/packages/
                '';
              };
          # Use this to test nix-build on your local GHC checkout.
          # src = lib.cleanSource ./ghc;
          hardeningDisable = drv.hardeningDisable or []
            ++ ["stackprotector"]
            ++ lib.optional crossSystem.isWasm "pic";
          dontDisableStatic = true;
          NIX_NO_SELF_RPATH=1;
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (self: super: {
          mkDerivation = args: super.mkDerivation (args // {
            dontStrip = true;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            enableDeadCodeElimination = false;
            doHaddock = !crossSystem.isWasm;
            configureFlags = args.configureFlags or [] ++
              lib.optionals
                crossSystem.isWasm
                ["--ghc-option=-optl" "--ghc-option=-Wl,--export=main"];
          });
        });
      });
    };
  };
}

