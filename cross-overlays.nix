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
          ghcSingleThreaded = crossSystem.arch or null == "wasm32";
          # quick-cross = true; # Just for dev
        }).overrideDerivation (drv: {
          # Use this to test nix-build on your local GHC checkout.
          # src = lib.cleanSource ./ghc;
        });
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
}

