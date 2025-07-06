[![CI](https://github.com/silver-signal/zig-bzip2/actions/workflows/ci.yaml/badge.svg)](https://github.com/silver-signal/zig-bzip2/actions)

# bzip2
This is [bzip2](https://sourceware.org/bzip2/index.html), packaged for [Zig](https://ziglang.org/).

## Installation

First, update your `build.zig.zon`:

```
# Initialize a `zig build` project if you haven't already
zig init
zig fetch --save git+https://github.com/silver-signal/zig-bzip2#1.0.8
```

You can then import the `bz2` library in your `build.zig` with:

```zig
const bzip2_dependency = b.dependency("bzip2", .{
    .target = target,
    .optimize = optimize,
});
your_exe.linkLibrary(bzip2_dependency.artifact("bz2"));
```

The `bzip2` and `bzip2recovery` executables are also available to build.

