const std = @import("std");

const App = @import("../app.zig").App;
const Todo = @import("../todo.zig").Todo;
const getTaskId = @import("cmd.zig").getTaskId;

const stdout = std.io.getStdOut().writer();

pub fn delete(allocator: std.mem.Allocator, app: *App, args: ?[][:0]u8) void {
    if (args) |a| {
        if (getTaskId(a[1], app.todos.items.len)) |id| {
            const deleted_todo = app.todos.orderedRemove(id);
            stdout.print("Deleted todo\n", .{}) catch unreachable;
            deleted_todo.print();
            deleted_todo.deinit(allocator);
            app.saveTodos(allocator, app.path);
        }
    } else {
        stdout.print("No argument for delete", .{}) catch |err| {
            std.log.err("pirnt error: {}", .{err});
        };
    }
}
