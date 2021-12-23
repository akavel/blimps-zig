const std = @import("std");
const autolua = @import("autolua");
const lua = autolua.lua;
var allocator = std.heap.page_allocator;

pub fn main() anyerror!void {
    // std.log.info("All your codebase are belong to us.", .{});

    // Create Lua state and initialize it with default libraries.
    const L = try autolua.newState(&allocator);
    defer lua.lua_close(L);
    lua.luaL_openlibs(L);

    // Recursively find all file names below current dir and put them into Lua global table 'files'
    lua.lua_newtable(L);
    {
        var dir = try std.fs.cwd().openDir(".", .{
            .iterate = true,
        });
        defer dir.close();

        var walker = try dir.walk(allocator);
        defer walker.deinit();

        var i: u32 = 1;
        while (try walker.next()) |entry| {
            if (entry.kind != .File)
                continue;

            autolua.push(L, i);
            autolua.push(L, entry.path);
            lua.lua_settable(L, -3);
            i += 1;
        }
    }
    lua.lua_setglobal(L, "files");

    if (lua.luaL_loadstring(L, "print 'hello from Lua!' print('* ' .. files[1])") != lua.LUA_OK) {
        @panic("failed to load Lua string");
    }
    if (lua.lua_pcallk(L, 0, 0, 0, 0, null) != lua.LUA_OK) {
        @panic("failed to exec Lua string");
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
