const std = @import("std");

const App = @import("../app.zig").App;
const Todo = @import("../todo.zig").Todo;
const getTaskId = @import("cmd.zig").getTaskId;

const stdout = std.io.getStdOut().writer();

pub fn changeTodoState(allocator: std.mem.Allocator, app: *App, args: ?[][:0]u8, state: Todo.State) void {
    if (args) |a| {
        if (getTaskId(a[1], app.todos.items.len)) |id| {
            if (id <= app.todos.items.len) {
                app.todos.items[id].state = state;
                app.todos.items[id].print();
                app.saveTodos(allocator, app.path);
            } else {
                stdout.print("invalid ID: {d}", .{id}) catch |err| {
                    std.log.err("pirnt error: {}", .{err});
                };
            }
        }
    } else {
        stdout.print("No argument for done", .{}) catch |err| {
            std.log.err("pirnt error: {}", .{err});
        };
    }
}
