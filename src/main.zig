const std = @import("std");
const lua = @import("lua");
const autolua = @import("autolua");
var allocator = std.heap.page_allocator;

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    const L = try autolua.newState(&allocator);
    defer lua.lua_close(L);
    lua.luaL_openlibs(L);
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
