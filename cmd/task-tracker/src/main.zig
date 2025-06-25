const std = @import("std");

const store = @import("store.zig");
const App = @import("app.zig").App;
const Todo = @import("todo.zig").Todo;
const Cmd = @import("cmd/cmd.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = std.process.argsAlloc(allocator) catch |err| {
        std.log.err("err processing args: {}", .{err});
        return;
    };
    defer std.process.argsFree(allocator, args);

    const path = "./data/todos.json";

    var app = try App.init(allocator, path);
    defer app.deinit(allocator);

    const arg = if (args.len > 1) args[1..] else null;

    try Cmd.cmd(allocator, &app, arg);
}

test {
    std.testing.refAllDecls(@This());
}
