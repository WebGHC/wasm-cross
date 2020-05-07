{ build-wasm-app }:
self: super: {
  inherit build-wasm-app;
  fib-example = self.callPackage ./fib-example {};

  hello-example = self.callPackage ./hello-example {};

  haskell-example = self.build-wasm-app { ename = "hello"; pkg = self.haskell.packages.ghcWasm.hello; };

  # Issue happens when combining pkgsStatic & custom cross stdenv.
  # We need to force a normal busybox here to avoid hitting a
  # weird bootstrapping issue.
  busybox-sandbox-shell = super.busybox-sandbox-shell.override { busybox = self.busybox; };
}
