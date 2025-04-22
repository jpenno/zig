const std = @import("std");
const App = @import("../app.zig").App;
const Todo = @import("../todo.zig").Todo;

const stdout = std.io.getStdOut().writer();

pub const Commands = enum {
    add,
    delete,
    list,
    inprogress,
    done,
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
            if (checkArgs(args)) |a| {
                try app.todos.append(Todo.create(allocator, a[1]));
                app.saveTodos(allocator, app.path);
            } else {
                stdout.print("No argument for add", .{}) catch |err| {
                    std.log.err("pirnt error: {}", .{err});
                };
            }
        },
        .delete => {
            if (checkArgs(args)) |a| {
                if (getTaskId(a[1])) |id| {
                    const deleted_todo = app.todos.orderedRemove(id - 1);
                    stdout.print("Deleted todo\n", .{}) catch unreachable;
                    deleted_todo.print(allocator);
                    deleted_todo.deinit(allocator);
                    app.saveTodos(allocator, app.path);
                }
            } else {
                stdout.print("No argument for delete", .{}) catch |err| {
                    std.log.err("pirnt error: {}", .{err});
                };
            }
        },
        .done => {
            if (checkArgs(args)) |a| {
                if (getTaskId(a[1])) |id| {
                    app.todos.items[id].state = .Done;
                    app.todos.items[id].print(allocator);
                    app.saveTodos(allocator, app.path);
                }
            } else {
                stdout.print("No argument for done", .{}) catch |err| {
                    std.log.err("pirnt error: {}", .{err});
                };
            }
        },
        .inprogress => {
            if (checkArgs(args)) |a| {
                if (getTaskId(a[1])) |id| {
                    app.updateState(allocator, id, .In_progress);
                }
            } else {
                stdout.print("No argument for done", .{}) catch |err| {
                    std.log.err("pirnt error: {}", .{err});
                };
            }
        },
        .list => {
            stdout.print("Id | todo | state\n", .{}) catch unreachable;
            for (app.todos.items) |todo| {
                todo.print(allocator);
            }
        },
        .invalid_command => {
            if (checkArgs(args)) |a| {
                stdout.print("inavlid command: \"{s}\"", .{a[0]}) catch unreachable;
            }
        },
    }
}

fn checkArgs(args: ?[][:0]u8) ?[][:0]u8 {
    if (args) |a| {
        if (a.len >= 1) {
            return a;
        }
    }
    return null;
}

fn getTaskId(arg: [:0]u8) ?usize {
    const id = std.fmt.parseInt(usize, arg, 10) catch |err|
        switch (err) {
            std.fmt.ParseIntError.InvalidCharacter => {
                stdout.print("Invalid id: {s}", .{arg}) catch unreachable;
                return null;
            },
            std.fmt.ParseIntError.Overflow => {
                return null;
            },
        };

    return id - 1;
}
