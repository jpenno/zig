const std = @import("std");

const App = @import("../app.zig").App;
const Todo = @import("../todo.zig").Todo;
const Todos = @import("../todos.zig");
const add = @import("add.zig").add;
const delete = @import("delete.zig").delete;
const changeTodoState = @import("changeTodoState.zig").changeTodoState;

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
    input: ?[][:0]u8,
) !void {
    const args: [][:0]u8 = if (input) |a| a else return;

    const command: Commands =
        std.meta.stringToEnum(Commands, args[0]) orelse .invalid_command;

    switch (command) {
        .add => {
            app.addToDo(allocator, add(allocator, args));
        },
        .delete => {
            delete(allocator, app, args);
        },
        .done => {
            changeTodoState(allocator, app, args, .done);
        },
        .inprogress => {
            changeTodoState(allocator, app, args, .in_progress);
        },
        .list => {
            const state: Todo.State = if (args.len >= 2)
                std.meta.stringToEnum(Todo.State, args[1]) orelse .invalid
            else
                .invalid;

            if (state != .invalid) {
                stdout.print("Id | todo | state\n", .{}) catch unreachable;
                Todos.printTodos(app.todos.items, state);
            } else {
                Todos.printTodos(app.todos.items, null);
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

pub fn getTaskId(arg: [:0]u8, max: ?usize) ?usize {
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

    if (max) |m| {
        if (id > m) {
            stdout.print("ID is out of range: {s}", .{arg}) catch unreachable;
            return null;
        }
    }

    return id - 1;
}
