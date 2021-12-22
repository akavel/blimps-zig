const std = @import("std");
const pkgs = @import("deps.zig").pkgs;

// Run with: `zig build run`
pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("blimps-zig", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    pkgs.addAllTo(exe);
    exe.addIncludeDir(lua_root);
    exe.addCSourceFiles(lua_srcs, &.{});
    exe.linkSystemLibrary("c");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

const lua_root = ".gyro/github.com-tiehuis-zig-lua-archive-bb4e2759304b4b38df10919a499528fadfe33632.tar.gz/pkg/zig-lua-bb4e2759304b4b38df10919a499528fadfe33632/lua-5.3.4/src/";

const lua_srcs = &.{
    lua_root ++ "lapi.c",
    lua_root ++ "lauxlib.c",
    lua_root ++ "lbaselib.c",
    lua_root ++ "lbitlib.c",
    lua_root ++ "lcode.c",
    lua_root ++ "lcorolib.c",
    lua_root ++ "lctype.c",
    lua_root ++ "ldblib.c",
    lua_root ++ "ldebug.c",
    lua_root ++ "ldo.c",
    lua_root ++ "ldump.c",
    lua_root ++ "lfunc.c",
    lua_root ++ "lgc.c",
    lua_root ++ "linit.c",
    lua_root ++ "liolib.c",
    lua_root ++ "llex.c",
    lua_root ++ "lmathlib.c",
    lua_root ++ "lmem.c",
    lua_root ++ "loadlib.c",
    lua_root ++ "lobject.c",
    lua_root ++ "lopcodes.c",
    lua_root ++ "loslib.c",
    lua_root ++ "lparser.c",
    lua_root ++ "lstate.c",
    lua_root ++ "lstring.c",
    lua_root ++ "lstrlib.c",
    lua_root ++ "ltable.c",
    lua_root ++ "ltablib.c",
    lua_root ++ "ltm.c",
    // lua_root ++ "lua.c",
    // lua_root ++ "luac.c",
    lua_root ++ "lundump.c",
    lua_root ++ "lutf8lib.c",
    lua_root ++ "lvm.c",
    lua_root ++ "lzio.c",
};
