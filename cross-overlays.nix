{ lib
, localSystem, crossSystem, config, overlays
}:

self: super: {
  libiconvReal =
    if crossSystem.arch or null == "wasm32"
    then super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];})
    else super.libiconvReal;
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something

  haskellPackages = self.haskell.packages.ghcHEAD;
  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcHEAD = haskell.packages.ghcHEAD.override (drv: {
        ghc = (drv.ghc.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          with-terminfo = false;
          dontStrip = true;
          dontUseLibFFIForAdjustors = crossSystem.arch or null == "wasm32";
          disableFFI = crossSystem.arch or null == "wasm32";
          # quick-cross = true; # Just for dev
        }).overrideDerivation (drv: {
          src =
            if !(crossSystem.arch or null == "wasm32")
              then drv.src
              else self.buildPackages.fetchgit {
                url = "https://github.com/WebGHC/ghc.git";
                rev = "7f1605d3ce7e5db14b851344f1feabf731399324";
                sha256 = "18piw0ziq1w650hdwsxd3yrvnh6v36wfak6s6imil3xypi4qd2gf";
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
            ++ lib.optional (crossSystem.arch == "wasm32") "pic";
          dontDisableStatic = true;
          NIX_NO_SELF_RPATH=1;
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (self: super: {
          mkDerivation = args: super.mkDerivation (args // {
            enableExecutableStripping = false;
            enableLibraryStripping = false;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            doHaddock = !(crossSystem.arch or null == "wasm32");
            configureFlags = args.configureFlags or [] ++
              lib.optionals
                (crossSystem.arch or null == "wasm32")
                ["--ghc-option=-optl" "--ghc-option=-Wl,--export=main"];
          });
        });
      });
    };
  };
}

