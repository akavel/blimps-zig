const std = @import("std");
const autolua = @import("autolua");
const lua = autolua.lua;
var allocator = std.heap.page_allocator;

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    const L = try autolua.newState(&allocator);
    defer lua.lua_close(L);
    lua.luaL_openlibs(L);

    if (lua.luaL_loadstring(L, "print 'hello from Lua!'") != lua.LUA_OK) {
        @panic("failed to load Lua string");
    }
    if (lua.lua_pcallk(L, 0, 0, 0, 0, null) != lua.LUA_OK) {
        @panic("failed to exec Lua string");
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
