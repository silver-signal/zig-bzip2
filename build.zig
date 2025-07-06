const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.step("check", "Check that build.zig compiles. Used by zls for analysis.");

    const upstream = b.dependency("bzip", .{});

    const big_files = &.{"-D_FILE_OFFSET_BITS=64"};
    const flags: []const []const u8 = &.{ "-Wall", "-Winline", "-O2", "-g" } ++ big_files;

    const bz2_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    bz2_mod.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = bz2_src,
        .flags = flags,
    });

    const bz2 = b.addLibrary(.{
        .name = "bz2",
        .root_module = bz2_mod,
    });
    b.installArtifact(bz2);

    const bzip2_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    bzip2_mod.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = bzip2_src,
        .flags = flags,
    });
    bzip2_mod.linkLibrary(bz2);

    const bzip2 = b.addExecutable(.{
        .name = "bzip2",
        .root_module = bzip2_mod,
    });
    b.installArtifact(bzip2);

    const bzip2recover_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    bzip2recover_mod.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = bzip2recover_src,
        .flags = flags,
    });
    const bzip2_recover = b.addExecutable(.{
        .name = "bzip2recover",
        .root_module = bzip2recover_mod,
    });
    b.installArtifact(bzip2_recover);
}

const bzip2_src: []const []const u8 = &.{
    "bzip2.c",
};

const bz2_src: []const []const u8 = &.{
    "blocksort.c",
    "huffman.c",
    "crctable.c",
    "randtable.c",
    "compress.c",
    "decompress.c",
    "bzlib.c",
};

const bzip2recover_src: []const []const u8 = &.{
    "bzip2recover.c",
};
