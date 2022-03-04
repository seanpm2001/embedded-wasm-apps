[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

# embedded-wasm-apps
Run **native, statically-compiled** apps on any platform, using WebAssembly.  
Examples include [<img src="https://cdn.rawgit.com/simple-icons/simple-icons/develop/icons/assemblyscript.svg" width="18" height="18" /> AssemblyScript](apps/assemblyscript/app.ts), 
[<img src="https://cdn.rawgit.com/simple-icons/simple-icons/develop/icons/rust.svg" width="18" height="18" /> Rust](apps/rust/src/app.rs), 
[<img src="https://cdn.rawgit.com/simple-icons/simple-icons/develop/icons/cplusplus.svg" width="18" height="18" /> C/C++](apps/cpp/app.cpp), 
[<img src="https://cdn.rawgit.com/simple-icons/simple-icons/develop/icons/go.svg" width="18" height="18" /> TinyGo](apps/tinygo/app.go), 
[<img src="https://cdn.rawgit.com/simple-icons/simple-icons/develop/icons/zig.svg" width="18" height="18" /> Zig](apps/zig/main.zig), 
etc.

## How it works

This **does not** use [`Wasm3`](https://github.com/wasm3/wasm3) engine. The approach is similar to [`WasmBoxC`](https://kripken.github.io/blog/wasm/2020/07/27/wasmboxc.html) or [`RLBox`](https://hacks.mozilla.org/2020/02/securing-firefox-with-webassembly/):

1. Compile source code to `wasm`
2. Translate `wasm` to `C` using [`wasm2c`](https://github.com/WebAssembly/wabt/blob/main/wasm2c/README.md)
3. Compile produced `C`, link with a thin runtime implementation using the **native platform toolchain**

![How it works](docs/how-it-works.png)

## Benefits
- Language/toolchain decoupling
- Resilience against attacks (RCE, Control-flow hijacking)
- Sandboxing / SFI (Software Fault Isolation)
- Enables wasm transformations, like instrumentation or [`gas metering`](https://github.com/wasm3/wasm3/blob/main/docs/Cookbook.md#gas-metering)
- Software-based memory virtualization
- Moderate runtime overhead (mostly depends on the source language/runtime)
    - Small performance hit (~50% slowdown)
    - Moderate binary size increase
- Highly portable

## Example
```log
$ make APP=rust
    Finished release [optimized] target(s) in 0.00s
$ pio run -e esp32 -t upload
$ pio device monitor
Initializing WebAssembly...
🦀 Rust is running!

$ make APP=assemblyscript
    > npm run asbuild:optimized
$ pio run -e esp32 -t upload
$ pio device monitor
Initializing WebAssembly...
🚀 AssemblyScript is running!

$ make APP=tinygo
$ pio run -e esp32 -t upload
$ pio device monitor
Initializing WebAssembly...
🤖 TinyGo is running!
```

## Building `WASM` apps

Ensure [`WABT`](https://github.com/WebAssembly/wabt) and [`Binaryen`](https://github.com/WebAssembly/binaryen) tools are in your `PATH`.

```sh
# AssemblyScript (needs Node.js)
cd apps/assemblyscript
npm install
cd ../..
make APP=assemblyscript

# Rust
rustup target add wasm32-unknown-unknown
make APP=rust

# C/C++ (needs wasienv)
make APP=cpp

# TinyGo (needs TinyGo v0.21.0 and Go v1.17.3)
make APP=tinygo

# Zig (needs Zig v0.9.0)
make APP=zig
```

## Building and running with `PlatformIO`

```sh
# For ESP32:
pio run -e esp32 -t upload

# For ESP8266:
pio run -e esp8266 -t upload

# For Raspberry Pi Pico:
pio run -e rpi-pico -t upload

# Open serial monitor
pio device monitor --quiet
```

## Building and running with `Particle`

Requires [`particle-cli`](https://docs.particle.io/tutorials/developer-tools/cli/).
Should work on all Particle devices i.e. `Spark Core`, `Photon`, `Electron`, `Argon`, `Boron`:

```sh
particle flash MyDevice ./src/

# Open serial monitor
particle serial monitor --follow
```

### License
This project is released under The MIT License (MIT)
