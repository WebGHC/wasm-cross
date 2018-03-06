This branch is a trivial PR to test Hydra PR CI

wasm-cross
---

`wasm-cross` provides a generic toolchain for cross compiling, with a
primary focus on targeting WebAssembly. Currently, `wasm-cross` can be
used to build "Hello, World!" C programs for
`aarch64-unknown-linux-gnu`, Raspberry Pi, and
`wasm32-unknown-uknown-wasm`. It can use GHC to cross compile Haskell
to aarch64, and work is ongoing to cross compile Haskell to Raspberry
Pi and WebAssembly.

The C toolchain is made up of Clang / LLVM, LLD, and [a fork of
musl](https://github.com/WebGHC/musl). `wasm-cross` builds all of
these from near-HEAD checkouts in order to keep up with the
bleeding-edge WebAssembly support. By statically linking everything,
this toolchain can be made to work for many platforms. WebAssembly is
becoming increasingly supported, as work on LLVM, LLD, and musl adds
support for it.

`fib-example` and `hello-example` show that this behaves just like a
standard cross compilation toolchain, even for
WebAssembly. `fib-example` demonstrates C code that does not need
`libc` (though the build system does not reflect
this). `hello-example` demonstrates some basic syscalls implemented by
`libc`.

GHC cross compilers are built from [a
fork](https://github.com/WebGHC/ghc) using the Nix infrastructure
largely developed by John Ericson (@Ericson2314), producing a working
`haskellPackages`. This fork is developing support for
WebAssembly. `wasm-cross` configures it with no dynamic
linking. Currently, GHC only works for aarch64.

When building for WebAssembly, the build product will simply be a wasm
binary. To run this in a browser, you will need the JS kernel and some
HTML wrapper. The `build-wasm-app` Nix function can help with this. It
uses [`webabi`](https://github.com/WebGHC/webabi) as a kernel to
support `musl`'s syscalls.

### Notes

1. We have [forked
   `nixpkgs`](https://github.com/WebGHC/nixpkgs/tree/wasm-cross) in
   order to support a variety of custom needs. As this gets cleaned
   up, it will be upstreamed.
2. If you're using Linux, a Nix binary cache is available at
   https://nixcache.webghc.org with a public key of:

   `hydra.webghc.org-1:knW30Yb8EXYxmUZKEl0Vc6t2BDjAUQ5kfC1BKJ9qEG8=`
