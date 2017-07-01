wasm-cross
---

This repo contains the nix expressions necessary to build cross a
compiling toolchain for WebAssembly. A secondary goal of this repo is
to make it easy or trivial to build cross compiling toolchains for
arbitrary LLVM targets.

### Design

1. `./llvm-head` contains the nix expressions for building LLVM,
   Clang, and various LLVM libraries from near-head checkouts. The
   libraries are automatically built to target whatever system Nixpkgs
   is targetting in the `host == target` stage. But Clang is not built
   with the cross system set as its default target in the `host ==
   build` stage because it's better to have a single build of Clang
   that `stdenv` massages into targetting the appropriate
   platform. This avoids needlessly rebuilding Clang many times when
   it's perfectly capable of targetting many platforms with the same
   binary.
2. `./musl-cross.nix` uses
   [a fork of `musl`](https://github.com/jfbastien/musl) for a
   portable `libc`. Building it for WebAssembly is currently
   incomplete, as it's missing several standard functions.  The nix
   expression configures building it for cross systems.  Currently,
   there are some hacks to make things build into static
   libraries. Static vs shared needs to be formalized in Nixpkgs.
3. `./cross.nix` defines the cross compiling stages. The first stages
   are the vanilla boot stages, which produce a normal Nixpkgs. The
   next stage builds a `cc-wrapper` around Clang that targets the
   cross system using `compiler-rt` as the runtime, and
   `musl-cross.nix` as the `libc`. The final stage uses a `stdenv`
   that will target the cross system by default.

### Notes

1. Upstream `lld` does not yet support the `wasm` ABI. We use
   [a fork](https://github.com/sbc100/lld/tree/add_wasm_linker) that does support it, along
   with
   [a few minor changes of our own](https://github.com/WebGHC/lld)
   (which are awaiting upstreaming).
2. We also forked the `musl` fork in order to streamline the build
   process for WebAssembly, but have yet to accomplish that goal.
