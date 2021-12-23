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

    // Push helper func allowing to create a directory from Lua
    lua.lua_pushcclosure(L, struct {
        fn thunk(LL: ?*lua.lua_State) callconv(.C) c_int {
            const path = autolua.check(LL, 1, []const u8);

            // FIXME: return errors instead of throwing
            var dir = std.fs.cwd().openDir(".", .{}) catch {
                return lua.luaL_error(LL, "mkdir: failed to open current directory");
            };
            defer dir.close();
            dir.makePath(path) catch {
                // FIXME: more details about the error
                return lua.luaL_error(LL, "mkdir: failed to create directory");
            };
            return 0;
        }
    }.thunk, 0);
    lua.lua_setglobal(L, "mkdir");

    if (lua.luaL_loadstring(L, "print 'hello from Lua!' print('* ' .. files[1]) mkdir('asdf/fff')") != lua.LUA_OK) {
        @panic("failed to load Lua string");
    }
    if (lua.lua_pcallk(L, 0, 0, 0, 0, null) != lua.LUA_OK) {
        @panic("failed to exec Lua string");
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
