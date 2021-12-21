const std = @import("std");
const Pkg = std.build.Pkg;
const FileSource = std.build.FileSource;

pub const pkgs = struct {
    pub const autolua = Pkg{
        .name = "autolua",
        .path = FileSource{
            .path = ".gyro\\github.com-daurnimator-zig-autolua-archive-0dba248465b6b8a7219f2b8f1141d71300715941.tar.gz\\pkg\\zig-autolua-0dba248465b6b8a7219f2b8f1141d71300715941\\src\\autolua.zig",
        },
    };

    pub fn addAllTo(artifact: *std.build.LibExeObjStep) void {
        artifact.addPackage(pkgs.autolua);
    }
};
