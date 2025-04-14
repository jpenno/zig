const std = @import("std");
const App = @import("../app.zig").App;
const Todo = @import("../todo.zig").Todo;

const stdout = std.io.getStdOut().writer();

pub const Commands = enum {
    add,
    delete,
    list,
    invalid_command,
};

pub fn cmd(
    allocator: std.mem.Allocator,
    app: *App,
    args: ?[][:0]u8,
) !void {
    const command: Commands = if (args) |a|
        std.meta.stringToEnum(Commands, a[0]) orelse .invalid_command
    else
        .invalid_command;

    switch (command) {
        .add => {
            if (args) |a| {
                try app.todos.append(Todo.create(allocator, a[1]));
                app.saveTodos(allocator, app.path);
            }
        },
        .delete => {
            if (args) |a| {
                const delete_id = try std.fmt.parseInt(usize, a[1], 10);
                const deleted_todo = app.todos.orderedRemove(delete_id - 1);
                stdout.print("Deleted todo\n", .{}) catch unreachable;
                deleted_todo.print(allocator);
                deleted_todo.deinit(allocator);

                app.saveTodos(allocator, app.path);
            }
        },
        .list => {
            stdout.print("Id | todo | state\n", .{}) catch unreachable;
            for (app.todos.items) |todo| {
                todo.print(allocator);
            }
        },
        .invalid_command => {
            if (args) |a| {
                std.log.err("inavlid command: \"{s}\"", .{a[0]});
            }
        },
    }
}
