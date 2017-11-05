{ lib
, localSystem, crossSystem, config, overlays
}:

self: super: {
  ncurses = (super.ncurses.override { androidMinimal = true; }).overrideDerivation (drv: {
    # patches = drv.patches or [] ++ [./ncurses.patch];
    configureFlags = drv.configureFlags or []
      ++ self.lib.optionals (crossSystem.arch == "wasm32") ["--without-progs" "--without-tests"];
  });
  haskellPackages = self.haskell.packages.ghcHEAD;
  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcHEAD = haskell.packages.ghcHEAD.override (drv: {
        ghc = drv.ghc.override {
          # dynamic = false;
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
}

