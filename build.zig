const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.step("check", "Check that build.zig compiles. Used by zls for analysis.");

    const upstream = b.dependency("bzip", .{});

    const bz2_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    bz2_mod.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = bz2_src,
        .flags = &.{}, // TODO
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
        .flags = &.{}, // TODO
    });
    const exe = b.addExecutable(.{
        .name = "bzip2",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);
}

const bzip2_src: []const []const u8 = &.{"bzip2.c"} ++ bz2_src;

const bz2_src: []const []const u8 = &.{
    "blocksort.c",
    "huffman.c",
    "crctable.c",
    "randtable.c",
    "compress.c",
    "decompress.c",
    "bzlib.c",
};
