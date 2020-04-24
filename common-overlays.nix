self: super: {
  fib-example = self.callPackage ./fib-example {};

  hello-example = self.callPackage ./hello-example {};

  haskell-example = self.build-wasm-app { ename = "hello"; pkg = self.haskell.packages.ghcWasm.hello; };

  webabi = self.callPackage ./webabi-nix {};

  webghc-runner = self.writeShellScriptBin "webghc-runner" ''
    exec ${self.nodejs-8_x}/bin/node ${self.webabi}/lib/node_modules/webabi/build/node_runner.js "$@"
  '';

  build-wasm-app = self.callPackage ./build-wasm-app.nix {};

  # Issue happens when combining pkgsStatic & custom cross stdenv.
  # We need to force a normal busybox here to avoid hitting a
  # weird bootstrapping issue.
  busybox-sandbox-shell = super.busybox-sandbox-shell.override { busybox = self.busybox; };
}
